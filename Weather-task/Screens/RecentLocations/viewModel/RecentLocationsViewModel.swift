//
//  RecentLocationsViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import RxRelay
import RxSwift
import UIKit

enum RecentLocationNextScreen {
    case selectLocation(viewModel: SelectLocationViewModel)
    case locationWeather(viewModel: LocationWeatherViewModel)
}
enum TableCellUpdate {
    case reload(indexes: [IndexPath])
    case insert(indexes: [IndexPath])
    case delete(indexes: [IndexPath])
}

class RecentLocationsViewModel {
    let weatherProvider: WeatherAPIClient
    let recentCitiesProvider: RecentlyViewedCitiesProvider
    let iconProvider: WeatherIconProvider
    let locationService: LocationService
    let cityProvider: CityProvider
    
    var locationModels = [LocationWeatherData]()
    
    lazy var cellsToUpdateObservable: Observable<TableCellUpdate> = {
        return cellsToUpdateRelay.compactMap { $0 }
    }()
    
    lazy var errorMessage: Observable<String> = {
        return errorMessageSubject.debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
    }()
    lazy var nextScreenObservable: Observable<RecentLocationNextScreen> = {
        return nextScreenSubject
    }()
    
    private let cellsToUpdateRelay = BehaviorRelay<TableCellUpdate?>(value: nil)
    private let nextScreenSubject = PublishSubject<RecentLocationNextScreen>()
    private let errorMessageSubject = PublishSubject<String>()
    
    init(recentCitiesProvider: RecentlyViewedCitiesProvider, weatherProvider: WeatherAPIClient, iconProvider: WeatherIconProvider, locationService: LocationService, cityProvider: CityProvider) {
        self.recentCitiesProvider = recentCitiesProvider
        self.weatherProvider = weatherProvider
        self.iconProvider = iconProvider
        self.locationService = locationService
        self.cityProvider = cityProvider
        
        recentCitiesProvider.loadRecentlyViewed { [weak self] (locations: [LocationWeatherData]) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.locationModels = locations
                var indexesToReload = [IndexPath]()
                for i in 0..<locations.count {
                    indexesToReload.append(IndexPath(row: i, section: 0))
                }
                self?.cellsToUpdateRelay.accept(.insert(indexes: indexesToReload))
                
            }
            
        }
    }
    
    func getModel(for indexPath: IndexPath) -> RecentLocationCellViewModel {
        let location = locationModels[indexPath.row]
        loadWeatherIfNeeded(for: location)
        
        return RecentLocationCellViewModel(from: location, imageLoader: iconProvider)
    }
    
    func addUserCoordinatesClicked() {
        addedUserLocation()
    }
    
    func customCoordinatesProvided(latitudeText: String?, longitudeText: String?) {
        guard let latitudeText = latitudeText,
            let longitudeText = longitudeText,
            let latitude = Double(latitudeText.replacingOccurrences(of: ",", with: ".")),
            let longitude = Double(longitudeText.replacingOccurrences(of: ",", with: ".")) else {
                errorMessageSubject.onNext("Incorrect coordinates provided")
                return
        }
        addedCoordinates(latitude: latitude, longitude: longitude)
    }
    
    func didSelectLocation(at index: Int) {
        let detailsViewModel = prepareDetailsViewModel(for: locationModels[index])
        nextScreenSubject.onNext(.locationWeather(viewModel: detailsViewModel))
    }
    
    func addLocationClicked() {
        let viewModel = SelectLocationViewModel(dataSource: CityDataSourceImpl(cityProvider: cityProvider))
        viewModel.addLocationDelegate = self
        nextScreenSubject.onNext(.selectLocation(viewModel: viewModel))
    }
    
    private func prepareDetailsViewModel(for location: LocationWeatherData) -> LocationWeatherViewModel {
        return LocationWeatherViewModel(location: location, weatherProvider: weatherProvider, weatherIconProvider: iconProvider, dateManager: ForecastDateManager())
    }
    
    func deleteLocation(at index: Int) {
        let location = locationModels.remove(at: index)
        recentCitiesProvider.removeFromRecentlyViewed(location: location)
    }
    
    private func loadWeatherIfNeeded(for location: LocationWeatherData) {
        guard let forecastTimestamp = location.forecastTimestamp else {
            loadWeather(for: location)
            return
        }
        if (Date().timeIntervalSince1970 - 360) > forecastTimestamp {
            loadWeather(for: location)
        }
    }
    
    private func loadWeather(for location: LocationWeatherData) {
        weatherProvider.loadCurrentWeather(latitude: location.cityCoordinates.latitude, longitude: location.cityCoordinates.longitude) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorMessageSubject.onNext(error.localizedDescription)
            case .success(let loadedLocation):
                var updatedLocation = location
                updatedLocation.currentWeather = loadedLocation.currentWeather
                updatedLocation.forecastTimestamp = Date().timeIntervalSince1970
                if let storedLocationIndex = self?.locationModels.firstIndex(where: { $0 == updatedLocation }) {
                    self?.locationModels[storedLocationIndex] = updatedLocation
                    self?.cellsToUpdateRelay.accept(.reload(indexes: [IndexPath(row: storedLocationIndex, section: 0)]))
                }
            }
        }
    }
}

protocol AddLocationDelegate: class {
    func added(location: LocationWeatherData)
    func addedCoordinates(latitude: Double, longitude: Double)
    func addedUserLocation()
}

extension RecentLocationsViewModel: AddLocationDelegate {
    func addedUserLocation() {
        locationService.getUserLocation(completion: { [weak self] result in
            switch result {
            case .success(let location):
                print("got location: \(location)")
                self?.addedCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            case .failure(let error):
                self?.errorMessageSubject.onNext(error.localizedDescription)
                print("got error on location request: \(error.localizedDescription)")
            }
        })
    }
    
    func added(location: LocationWeatherData) {
        recentCitiesProvider.storeAsRecentlyViewed(location: location)
        locationModels.append(location)
        cellsToUpdateRelay.accept(.insert(indexes: [IndexPath(row: locationModels.count - 1, section: 0)]))
        loadWeatherIfNeeded(for: location)
    }
    
    func addedCoordinates(latitude: Double, longitude: Double) {
        weatherProvider.loadCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .failure(let error):
                self.errorMessageSubject.onNext(error.localizedDescription)
            case .success(let location):
                self.added(location: location)
                
                let detailsViewModel = self.prepareDetailsViewModel(for: location)
                self.nextScreenSubject.onNext(.locationWeather(viewModel: detailsViewModel))
            }
        }
    }
}
