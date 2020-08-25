//
//  LocationWeatherData.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct LocationWeatherData: Codable {
    let uuid: UUID
    let cityId: Int?
    let cityName: String?
    let cityCoordinates: Coordinates
    let countryCode: String?
    var currentWeather: CurrentWeather?
    var forecastTimestamp: Double?
    
//    var descrtiption: String {
//        let name = cityName ?? "Loading..."
//        var countryDescription = ""
//        if let countryCode = countryCode {
//            countryDescription = ", \(countryCode)"
//        }
//        return name.appending(countryDescription)
//    }
}

extension LocationWeatherData {
    var storingKey: String {
        return "\(cityCoordinates.latitude),\(cityCoordinates.longitude)"
    }
}

extension LocationWeatherData: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
