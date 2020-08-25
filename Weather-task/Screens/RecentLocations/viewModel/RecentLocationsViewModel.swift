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

class RecentLocationsViewModel {
    let weatherProvider: WeatherAPIClient
    let recentCitiesProvider: RecentlyViewedCitiesProvider
    let iconProvider: WeatherIconProvider
    
    var locationModels = [LocationWeatherData]()
    let cellsToReload = BehaviorRelay<[IndexPath]>(value: [])
    let cellsToInsert = BehaviorRelay<[IndexPath]>(value: [])
    lazy var dataLoadingError: Observable<String> = {
        return dataLoadingErrorRelay.skip(1).compactMap { $0 }.debounce(.seconds(5), scheduler: MainScheduler.asyncInstance)
    }()
    
    private let dataLoadingErrorRelay = BehaviorRelay<String?>(value: nil)
    
    var onLocationAdd: ((IndexPath) -> Void)?
    init(recentCitiesProvider: RecentlyViewedCitiesProvider, weatherProvider: WeatherAPIClient, iconProvider: WeatherIconProvider) {
        self.recentCitiesProvider = recentCitiesProvider
        self.weatherProvider = weatherProvider
        self.iconProvider = iconProvider
        
        recentCitiesProvider.loadRecentlyViewed { [weak self] (locations: [LocationWeatherData]) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.locationModels = locations
                var indexesToReload = [IndexPath]()
                for i in 0..<locations.count {
                    indexesToReload.append(IndexPath(row: i, section: 0))
                }
                self?.cellsToInsert.accept(indexesToReload)
            }
            
        }
    }
    
    func getModel(for indexPath: IndexPath) -> RecentLocationCellViewModel {
        let location = locationModels[indexPath.row]
        loadWeatherIfNeeded(for: location)
        
        return RecentLocationCellViewModel(from: location, imageLoader: iconProvider)
    }
    
    func deleteLocation(at index: Int) {
        locationModels.remove(at: index)
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
            case .failure(_):
                self?.dataLoadingErrorRelay.accept("Problem with loading forecast")
            case .success(let currentWeather):
                var updatedLocation = location
                updatedLocation.currentWeather = currentWeather
                updatedLocation.forecastTimestamp = Date().timeIntervalSince1970
                if let storedLocationIndex = self?.locationModels.firstIndex(where: { $0 == updatedLocation }) {
                    self?.locationModels[storedLocationIndex] = updatedLocation
                    self?.cellsToReload.accept([IndexPath(row: storedLocationIndex, section: 0)])
                }
            }
            
            
        }
    }
}

protocol AddLocationDelegate: class {
    func added(location: LocationWeatherData)
}

extension RecentLocationsViewModel: AddLocationDelegate {
    func added(location: LocationWeatherData) {
        recentCitiesProvider.storeAsRecentlyViewed(location: location)
        locationModels.append(location)
        cellsToInsert.accept([IndexPath(row: locationModels.count - 1, section: 0)])
    }
}
