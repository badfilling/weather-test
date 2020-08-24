//
//  LocationWeatherViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class LocationWeatherViewModel {
    private var location: LocationWeatherData
    private let weatherProvider: WeatherAPIClient
    private let weatherIconProvider: WeatherIconProvider
    private let dataLoadingErrorRelay = BehaviorRelay<String?>(value: nil)
    private lazy var temperatureRelay: BehaviorRelay<String?> = {
        return BehaviorRelay(value: createTemperatureDescription())
    }()
    private lazy var titleRelay: BehaviorRelay<String?> = {
        return BehaviorRelay(value: createTitle())
    }()
    private lazy var weatherIconRelay: BehaviorRelay<UIImage?> = {
        return BehaviorRelay<UIImage?>(value: nil)
    }()
    
    lazy var dataLoadingErrorObservable: Observable<String> = {
        return dataLoadingErrorRelay.skip(1).compactMap { $0 }.debounce(.seconds(5), scheduler: MainScheduler.asyncInstance)
    }()
    lazy var titleObservable: Observable<String> = {
        return titleRelay.compactMap { $0 }
    }()
    lazy var temperatureObservable: Observable<String> = {
        return temperatureRelay.compactMap { $0 }
    }()
    lazy var weatherIconObservable: Observable<UIImage> = {
        return weatherIconRelay.compactMap { $0 }
    }()
    
    var collectionData: [WeatherDataSection] = []
    init(location: LocationWeatherData, weatherProvider: WeatherAPIClient, weatherIconProvider: WeatherIconProvider) {
        self.location = location
        self.weatherProvider = weatherProvider
        self.weatherIconProvider = weatherIconProvider
        loadWeatherIcon()
        loadWeatherIfNeeded(for: location)
        loadWeatherDetails()
    }
    
    private func createTitle() -> String {
        let cityName = location.cityName ?? ""
        let weatherCondition = location.currentWeather?.weatherConditionDescription ?? ""
        return "\(cityName)\n\(weatherCondition.capitalized)"
    }
    
    private func createTemperatureDescription() -> String? {
        if let temp = location.currentWeather?.temperature {
            return "\(temp)°"
        }
        return nil
    }
    
    private func loadWeatherIcon() {
        if let iconName = location.currentWeather?.weatherConditionIconName {
            _ = weatherIconProvider.setImage(for: iconName) { [weak self] data in
                if let data = data {
                    let image = UIImage(data: data)
                    self?.weatherIconRelay.accept(image)
                }
            }
        }
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
                self?.location.currentWeather = currentWeather
                self?.location.forecastTimestamp = Date().timeIntervalSince1970
                self?.updateBasicData()
            }
        }
    }
    
    private func loadWeatherDetails() {
        
    }
    
    private func updateBasicData() {
        temperatureRelay.accept(createTemperatureDescription())
        titleRelay.accept(createTitle())
        loadWeatherIcon()
    }
}

protocol WeatherDataCellViewModel {
    func dequeue(collectionView: UICollectionView) -> UICollectionViewCell
}

enum WeatherDataSection {
    case basicData(rows: [WeatherDataCellViewModel])
    case hourlyForecast(rows: [WeatherDataCellViewModel])
    case dailyForecast(rows: [WeatherDataCellViewModel])
    
    var rows: [WeatherDataCellViewModel] {
        switch self {
        case .basicData(let rows):
            return rows
        case .hourlyForecast(let rows):
            return rows
        case .dailyForecast(let rows):
            return rows
        }
    }
}
