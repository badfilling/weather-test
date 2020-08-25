//
//  DetailForecastDTO.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct DetailForecastDTO: Decodable {
    let list: [DetailForecastDataDTO]?
}

struct DetailForecastDataDTO: Decodable {
    let main: CurrentWeatherMainDTO?
    let weather: [WeatherConditionDTO]?
    let forecastDate: String?
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case forecastDate = "dt_txt"
    }
}

extension DetailForecastDataDTO {
    func convert() throws -> WeatherForecast {
        guard let temperature = main?.temperature,
            let maxTemperature = main?.maxTemperature,
            let minTemperature = main?.minTemperature,
            let dateISO = forecastDate else { throw NetworkError.dataCorrupted }
        return WeatherForecast(temperature: Int(temperature), maxTemperature: Int(maxTemperature), minTemperature: Int(minTemperature), dateISO: dateISO, weatherConditionIconName: weather?[0].icon)
    }
}
