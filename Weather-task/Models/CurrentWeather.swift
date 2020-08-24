//
//  CurrentWeather.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    let temperature: Double
    let temperatureFeelsLike: Double?
    let pressure: Double?
    let humidity: Double?
    let windSpeed: Double?
    let cloudsPercent: Double?
    let weatherConditionDescription: String?
    let weatherConditionIconName: String?
    let timezoneOffset: Int
    let cityName: String?
}
