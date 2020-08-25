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
    private lazy var tableReloadRelay: BehaviorRelay<Any?> = {
        return BehaviorRelay<Any?>(value: nil)
    }()
    
    lazy var dataLoadingErrorObservable: Observable<String> = {
        return dataLoadingErrorRelay.skip(1).compactMap { $0 }.debounce(.seconds(5), scheduler: MainScheduler.asyncInstance)
    }()
    lazy var tableReloadObservable: Observable<Any> = {
        return tableReloadRelay.skip(2).compactMap { $0 }
    }()
    
    var cellsData: [WeatherForecastSection: [AnyTableCellViewModel]] = [
        .primaryData: [BasicWeatherCellViewModel](),
        .basicData: [HourlyForecastCellViewModel](),
        .hourlyForecast: [HourlyForecastCellViewModel](),
        .dailyForecast: [HourlyForecastCellViewModel]()
    ]    
    init(location: LocationWeatherData, weatherProvider: WeatherAPIClient, weatherIconProvider: WeatherIconProvider, dateManager: ForecastDateManager) {
        self.location = location
        self.weatherProvider = weatherProvider
        self.weatherIconProvider = weatherIconProvider
        self.dateManager = dateManager
        updatePrimaryData()
        updateDetailParameters()
        
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
            return "\(Int(temp))°"
        }
        return nil
    }
    
    private func getTemperatureColor() -> UIColor {
        guard let temp = location.currentWeather?.temperature else { return .black }
        let casted = Int(temp)
        if casted < 10 { return .blue }
        if casted > 20 { return .red }
        return .black
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
                self?.updatePrimaryData()
                self?.updateDetailParameters()
            }
        }
    }
    
    private func loadWeatherDetails() {
        weatherProvider.loadForecast(latitude: location.cityCoordinates.latitude, longitude: location.cityCoordinates.longitude) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let forecasts):
                var todayForecasts = [WeatherForecast]()
                var nextDaysForecasts = [WeatherForecast]()
                for forecast in forecasts {
                    self.dateManager.isToday(utc: forecast.dateISO) ? todayForecasts.append(forecast) : nextDaysForecasts.append(forecast)
                }
                self.updateTodayDetails(with: todayForecasts)
                self.updateFutureDays(with: nextDaysForecasts)
            case .failure(_):
                self.dataLoadingErrorRelay.accept("Problem with loading forecast for future days")
            }
        }
    }
    
    func updatePrimaryData() {
        let primaryCellViewModel = BasicWeatherCellViewModel(temperatureDescription: createTemperatureDescription() ?? "Unknown", titleDescription: createTitle(), imageLoader: weatherIconProvider, weatherIconName: location.currentWeather?.weatherConditionIconName, temperatureLabelColor: getTemperatureColor())
        cellsData[.primaryData] = [primaryCellViewModel]
    }
    
    func updateDetailParameters() {
        var cellModels = [CurrentForecastCellViewModel]()
        if let currentWeather = location.currentWeather {
            cellModels.append(CurrentForecastCellViewModel(titleDescription: "Feels like", valueDescription: currentWeather.temperatureFeelsLike == nil ? "-" : "\(Int(currentWeather.temperatureFeelsLike!))°"))
            cellModels.append(CurrentForecastCellViewModel(titleDescription: "Humidity", valueDescription: currentWeather.humidity == nil ? "-" : "\(Int(currentWeather.humidity!))%"))
            cellModels.append(CurrentForecastCellViewModel(titleDescription: "Pressure", valueDescription: currentWeather.pressure == nil ? "-" : "\(Int(currentWeather.pressure!)) hPa"))
            cellModels.append(CurrentForecastCellViewModel(titleDescription: "Clouds", valueDescription: currentWeather.cloudsPercent == nil ? "-" : "\(Int(currentWeather.cloudsPercent!))%"))
            cellModels.append(CurrentForecastCellViewModel(titleDescription: "Wind", valueDescription: currentWeather.windSpeed == nil ? "-" : "\(currentWeather.windSpeed!) m/s"))
        }
        cellsData[.basicData] = cellModels
        tableReloadRelay.accept(())
    }
    
    func updateTodayDetails(with forecasts: [WeatherForecast]) {
        var cellModels = [HourlyForecastCellViewModel]()
        for forecast in forecasts {
            cellModels.append(HourlyForecastCellViewModel(temperatureDescription: "\(forecast.temperature)°", dateDescription: dateManager.hours(of: forecast.dateISO), imageLoader: weatherIconProvider, weatherIconName: forecast.weatherConditionIconName))
        }
        cellsData[.hourlyForecast] = cellModels
        tableReloadRelay.accept(())
    }
    
    func updateFutureDays(with forecasts: [WeatherForecast]) {
        var cellModels = [DailyForecastCellViewModel]()

        for forecast in forecasts {
            cellModels.append(DailyForecastCellViewModel(minTemperatureDescription: "\(forecast.minTemperature)°", maxTemperatureDescription: "\(forecast.maxTemperature)°", dateDescription: dateManager.dayWithTime(utc: forecast.dateISO) ?? "Unknown", imageLoader: weatherIconProvider, weatherIconName: forecast.weatherConditionIconName))
        }

        cellsData[.dailyForecast] = cellModels
        tableReloadRelay.accept(())
    }
}
