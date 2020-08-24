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
    private let dateManager: ForecastDateManager
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
    
    var cellsData: [Section: [AnyCellViewModel]] = [
        .basicData: [HourlyForecastCellViewModel](),
        .hourlyForecast: [HourlyForecastCellViewModel](),
        .dailyForecast: [HourlyForecastCellViewModel]()
    ]
    init(location: LocationWeatherData, weatherProvider: WeatherAPIClient, weatherIconProvider: WeatherIconProvider, dateManager: ForecastDateManager) {
        self.location = location
        self.weatherProvider = weatherProvider
        self.weatherIconProvider = weatherIconProvider
        self.dateManager = dateManager
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
        weatherProvider.loadForecast(latitude: location.cityCoordinates.latitude, longitude: location.cityCoordinates.longitude) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let forecasts):
                print("x")
                var todayForecasts = [WeatherForecast]()
                var nextDaysForecasts = [WeatherForecast]()
                for forecast in forecasts {
                    self.dateManager.isToday(utc: forecast.dateISO) ? todayForecasts.append(forecast) : nextDaysForecasts.append(forecast)
                }
            case .failure(_):
                self.dataLoadingErrorRelay.accept("Problem with loading forecast for future days")
            }
        }
    }
    
    func updateTodayDetails(with forecasts: [WeatherForecast]) {
//        let cellModels =
        for forecast in forecasts {
            
        }
        
    }
    
    private func updateBasicData() {
        temperatureRelay.accept(createTemperatureDescription())
        titleRelay.accept(createTitle())
        loadWeatherIcon()
    }
}

protocol AnyCellType: UICollectionViewCell {
    static var cellIdentifier: String { get }
    func setup(with model: AnyCellViewModel)
}
extension AnyCellType {
    static var cellIdentifier: String {
        return String(describing: Self.self)
    }
}


protocol AnyCellViewModel {
    func dequeue(collectionView: UICollectionView, for indexPath: IndexPath) -> AnyCellType
}

enum Section: Int {
    case basicData = 0
    case hourlyForecast
    case dailyForecast
}

class ForecastDateManager {
    let UTCformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    let currentTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h a"
        return formatter
    }()
    
    let calendar = Calendar.current
    
    func isToday(utc: String) -> Bool {
        guard let current = utcToLocal(utc: utc) else { return false }
        return calendar.isDateInToday(current)
    }
    
    func dayOfWeek(utc: String) -> String? {
        guard let currentDate = utcToLocal(utc: utc) else { return nil }
        return calendar.weekdaySymbols[calendar.component(.weekday, from: currentDate)]
    }
    
    private func utcToLocal(utc: String) -> Date? {
        guard let utc = UTCformatter.date(from: utc) else { return nil }
        let local = currentTimeFormatter.string(from: utc)
        return currentTimeFormatter.date(from: local)
    }
}
