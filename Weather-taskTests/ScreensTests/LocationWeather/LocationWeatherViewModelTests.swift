//
//  LocationWeatherViewModelTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
import RxSwift

@testable import Weather_task
class LocationWeatherViewModelTests: XCTestCase {
    
    var viewModel: LocationWeatherViewModel!
    var weatherProvider: WeatherAPIClientMock!
    var weatherIconProvider: WeatherIconProviderMock!
    var dateManager: ForecastDateManager!
    var disposeBag: DisposeBag!
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        weatherProvider = WeatherAPIClientMock()
        weatherIconProvider = WeatherIconProviderMock()
        dateManager = ForecastDateManager()
        viewModel = LocationWeatherViewModel(location: prepareLocation(), weatherProvider: weatherProvider, weatherIconProvider: weatherIconProvider, dateManager: dateManager)
    }
    
    
    func testPrimaryDataUpdatedOnLoad() {
        let exp = expectation(description: "primary date updated")
        
        viewModel.tableReloadObservable
            .filter { $0.contains(.primaryData) }
            .subscribe(onNext: { _ in
                exp.fulfill()
            }).disposed(by: disposeBag)
        
        viewModel.reloadData()
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testBasicDataUpdatedOnLoad() {
        let exp = expectation(description: "primary date updated")
        viewModel = LocationWeatherViewModel(location: prepareLocation(currentWeather: prepareCurrentWeather()), weatherProvider: weatherProvider, weatherIconProvider: weatherIconProvider, dateManager: dateManager)
        viewModel.tableReloadObservable
            .filter { $0.contains(.basicData) }
            .subscribe(onNext: { _ in
                exp.fulfill()
            }).disposed(by: disposeBag)
        
        viewModel.reloadData()
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testWeatherDetailsLoadedOnLoad() {
        let exp = expectation(description: "weather api for details called")
        
        viewModel.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.weatherProvider.forecastLoadedTimes > 0 {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testCurrentWeatherIsLoadedWhenCurrentIsNil() {
        viewModel = LocationWeatherViewModel(location: prepareLocation(currentWeather: nil), weatherProvider: weatherProvider, weatherIconProvider: weatherIconProvider, dateManager: dateManager)
        
        let exp = expectation(description: "weather api for current weather called")
        
        viewModel.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if self.weatherProvider.currentWeatherLoadedtimes > 0 {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testCurrentWeatherSavedWhenLoaded() {
        let weather = prepareCurrentWeather()
        weatherProvider.currentWeatherToReturn = prepareLocation(currentWeather: weather)
        viewModel = LocationWeatherViewModel(location: prepareLocation(currentWeather: nil), weatherProvider: weatherProvider, weatherIconProvider: weatherIconProvider, dateManager: dateManager)
        
        let exp = expectation(description: "correct weather is saved")
        
        viewModel.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.viewModel.location.currentWeather == weather {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testWeatherDetailsLoadedOnInit() {
        weatherProvider.forecastsToReturn = [prepareForecast()]
        viewModel = LocationWeatherViewModel(location: prepareLocation(currentWeather: nil), weatherProvider: weatherProvider, weatherIconProvider: weatherIconProvider, dateManager: dateManager)
        
        let exp1 = expectation(description: "hourly forecast updated")
        let exp2 = expectation(description: "daily forecast updated")
        viewModel.tableReloadObservable
            .filter { $0.contains(.dailyForecast) || $0.contains(.hourlyForecast) }
            .subscribe(onNext: { sections in
                if sections.contains(.dailyForecast) {
                    exp2.fulfill()
                }
                if sections.contains(.hourlyForecast) {
                    exp1.fulfill()
                }
            }).disposed(by: disposeBag)
        
        viewModel.reloadData()
        
        wait(for: [exp1, exp2], timeout: 0.2)
    }
    
    
    func prepareLocation(currentWeather: CurrentWeather? = nil) -> LocationWeatherData {
        return LocationWeatherData(uuid: UUID(), cityId: nil, cityName: nil, cityCoordinates: Coordinates(latitude: 0, longitude: 0), countryCode: nil, currentWeather: currentWeather, forecastTimestamp: nil)
    }
    
    func prepareCurrentWeather() -> CurrentWeather {
        return CurrentWeather(temperature: 0, temperatureFeelsLike: 0, pressure: 0, humidity: 0, windSpeed: 0, cloudsPercent: 0, weatherConditionDescription: nil, weatherConditionIconName: nil, timezoneOffset: 0, cityName: nil)
    }
    
    func prepareForecast() -> WeatherForecast {
        return WeatherForecast(temperature: 0, maxTemperature: 0, minTemperature: 0, dateISO: "", weatherConditionIconName: nil)
    }
}
