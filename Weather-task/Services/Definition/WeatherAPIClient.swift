//
//  WeatherAPIClient.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case dataCorrupted
    case invalidResponse
    case serverAccessProblem
    
    var errorDescription: String? {
        switch self {
        case .dataCorrupted:
            return "Weather data from server is corrupted"
        case .invalidResponse:
            return "Invalid server response"
        case .serverAccessProblem:
            return "Could not access server. Check your connection"
        }
    }
}

protocol WeatherAPIClient {
    @discardableResult
    func loadCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<LocationWeatherData, Error>) -> Void) -> URLSessionDataTask?
    @discardableResult
    func loadForecast(latitude: Double, longitude: Double, completion: @escaping (Result<[WeatherForecast], Error>) -> Void) -> URLSessionDataTask?
}
