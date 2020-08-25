//
//  CurrentWeatherMainDTO.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct CurrentWeatherMainDTO: Decodable {
    let temperature: Double
    let maxTemperature: Double?
    let minTemperature: Double?
    let temperatureFeelsLike: Double?
    let pressure: Double?
    let humidity: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureFeelsLike = "feels_like"
        case maxTemperature = "temp_max"
        case minTemperature = "temp_min"
        case pressure
        case humidity
    }
}
