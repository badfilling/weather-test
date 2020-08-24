//
//  WeatherAPIClient.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case dataCorrupted
    case invalidResponse
    case serverAccessProblem
}

protocol WeatherAPIClient {
    @discardableResult
    func loadCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) -> URLSessionDataTask?
    func loadForecast(latitude: Double, longitude: Double, completion: @escaping (Result<[WeatherForecast], Error>) -> Void) -> URLSessionDataTask?
}
