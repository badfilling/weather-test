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
    let main: CurrentWeatherMainDTO
    let wind: WindDTO?
    let clouds: CloudsDTO?
    let timezoneOffset: Int?
    let name: String?
    let coordinates: Coordinates
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case wind
        case clouds
        case timezoneOffset = "timezone"
        case name
        case coordinates = "coord"
        case id
    }
}

extension CurrentWeatherDTO {
    func convert() throws -> CurrentWeather {
        return CurrentWeather(temperature: main.temperature,
                              temperatureFeelsLike: main.temperatureFeelsLike,
                              pressure: main.pressure,
                              humidity: main.humidity,
                              windSpeed: wind?.speed,
                              cloudsPercent: clouds?.all,
                              weatherConditionDescription: weather?[0].description,
                              weatherConditionIconName: weather?[0].icon,
                              timezoneOffset: timezoneOffset ?? 0,
                              cityName: name)
    }
    
    func toLocation() throws -> LocationWeatherData {
        let weather = try self.convert()
        return LocationWeatherData(uuid: UUID(), cityId: id, cityName: name, cityCoordinates: coordinates, countryCode: nil, currentWeather: weather, forecastTimestamp: Date().timeIntervalSince1970)
    }
}
