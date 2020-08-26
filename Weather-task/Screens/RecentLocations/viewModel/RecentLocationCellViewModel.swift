//
//  RecentLocationCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

struct RecentLocationCellViewModel: WeatherIconImageSetService {
    let title: String
    let timestamp: String?
    let temperature: String
    
    let imageLoader: WeatherIconProvider
    let weatherIconName: String?
        
    init(from location: LocationWeatherData, imageLoader: WeatherIconProvider) {
        let temperature = location.currentWeather?.temperature == nil ? "" : "\(Int(location.currentWeather!.temperature))°"
        var timestamp = ""
        if let forecastTimestamp = location.forecastTimestamp, let offset = location.currentWeather?.timezoneOffset {
            let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + Double(offset) - Double(TimeZone.current.secondsFromGMT()))
            timestamp = date.getTime()
        }
        
        title = location.cityName ?? ""
        self.timestamp = timestamp
        self.temperature = temperature
        weatherIconName = location.currentWeather?.weatherConditionIconName
        self.imageLoader = imageLoader
    }
}
