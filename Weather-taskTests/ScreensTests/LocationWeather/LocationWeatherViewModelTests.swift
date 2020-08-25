//
//  LocationWeatherViewModelTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
@testable import Weather_task
class LocationWeatherViewModelTests: XCTestCase {

    var viewModel: LocationWeatherViewModel!
    var weatherProvider: WeatherAPIClientMock!
    var weatherIconProvider: WeatherIconProviderMock!
    var dateManager: ForecastDateManager!
    
    override func setUpWithError() throws {
        weatherProvider = WeatherAPIClientMock()
        weatherIconProvider = WeatherIconProviderMock()
        dateManager = ForecastDateManager()
        viewModel = LocationWeatherViewModel(location: prepareLocation(), weatherProvider: weatherProvider, weatherIconProvider: weatherIconProvider, dateManager: dateManager)
    }
    
    
    
    func prepareLocation() -> LocationWeatherData {
        return LocationWeatherData(uuid: UUID(), cityId: nil, cityName: nil, cityCoordinates: Coordinates(latitude: 0, longitude: 0), countryCode: nil, currentWeather: CurrentWeather(temperature: 0, temperatureFeelsLike: 0, pressure: 0, humidity: 0, windSpeed: 0, cloudsPercent: 0, weatherConditionDescription: nil, weatherConditionIconName: nil, timezoneOffset: 0, cityName: nil), forecastTimestamp: nil)
    }
}
