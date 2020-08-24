//
//  CurrentWeatherDTO.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
struct CurrentWeatherDTO: Decodable {
    let weather: [WeatherConditionDTO]?
    let main: CurrentWeatherMainDTO?
    let wind: WindDTO?
    let clouds: CloudsDTO?
    let timezoneOffset: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case wind
        case clouds
        case timezoneOffset = "timezone"
        case name
    }
}

struct CurrentWeatherMainDTO: Decodable {
    let temperature: Double?
    let temperatureFeelsLike: Double?
    let pressure: Double?
    let humidity: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureFeelsLike = "feels_like"
        case pressure
        case humidity
    }
}

struct WindDTO: Decodable {
    let speed: Double?
}

struct CloudsDTO: Decodable {
    let all: Double?
}
struct WeatherConditionDTO: Decodable {
    let description: String?
    let icon: String?
}

extension CurrentWeatherDTO {
    func convert() throws -> CurrentWeather {
        guard main?.temperature != nil else { throw NetworkError.dataCorrupted }
        return CurrentWeather(temperature: main!.temperature!,
                              temperatureFeelsLike: main?.temperatureFeelsLike,
                              pressure: main?.pressure,
                              humidity: main?.humidity,
                              windSpeed: wind?.speed,
                              cloudsPercent: clouds?.all,
                              weatherConditionDescription: weather?[0].description,
                              weatherConditionIconName: weather?[0].icon,
                              timezoneOffset: timezoneOffset ?? 0,
                              cityName: name)
    }
}
