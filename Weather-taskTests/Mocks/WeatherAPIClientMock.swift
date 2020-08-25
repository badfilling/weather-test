//
//  WeatherAPIClientMock.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import Weather_task
class WeatherAPIClientMock: WeatherAPIClient {
    var taskToReturn: URLSessionDataTask? = nil
    var currentWeatherToReturn: CurrentWeather? = nil
    var forecastsToReturn: [WeatherForecast]? = nil
    var currentWeatherLoadedtimes = 0
    
    func loadCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) -> URLSessionDataTask? {
        currentWeatherLoadedtimes += 1
        if currentWeatherToReturn != nil {
            completion(.success(currentWeatherToReturn!))
        }
        return nil
    }
    
    func loadForecast(latitude: Double, longitude: Double, completion: @escaping (Result<[WeatherForecast], Error>) -> Void) -> URLSessionDataTask? {
        return nil
    }
    
    
}
