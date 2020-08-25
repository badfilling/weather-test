//
//  WeatherForecastSection.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

enum WeatherForecastSection: Int, Comparable {
    static func < (lhs: WeatherForecastSection, rhs: WeatherForecastSection) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case primaryData = 0
    case basicData
    case hourlyForecast
    case dailyForecast
    
    var description: String {
        switch self {
        case .primaryData:
            return ""
        case .basicData:
            return "Basic data"
        case .hourlyForecast:
            return "Hourly forecasts"
        case .dailyForecast:
            return "Next days forecasts"
        }
    }
}
