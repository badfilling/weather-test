//
//  RecentLocationCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

struct RecentLocationCellViewModel {
    let title: String
    let timestamp: String?
    let temperature: String
    
    private let imageLoader: WeatherIconProvider
    private let weatherIconName: String?
    
    init(title: String, timestamp: String?, temperature: String, imageLoader: WeatherIconProvider, weatherIconName: String?) {
        self.title = title
        self.timestamp = timestamp
        self.temperature = temperature
        self.imageLoader = imageLoader
        self.weatherIconName = weatherIconName
    }
    
    init(from location: LocationWeatherData, imageLoader: WeatherIconProvider) {
        let temperature = location.currentWeather?.temperature == nil ? "" : "\(Int(location.currentWeather!.temperature))°"
        var timestamp = ""
        if let forecastTimestamp = location.forecastTimestamp, let offset = location.currentWeather?.timezoneOffset {
            let date = Date(timeIntervalSince1970: forecastTimestamp + Double(offset) - Double(TimeZone.current.secondsFromGMT()))
            timestamp = date.getTime()
        }
        
        title = location.cityName ?? ""
        self.timestamp = timestamp
        self.temperature = temperature
        weatherIconName = location.currentWeather?.weatherConditionIconName
        self.imageLoader = imageLoader
    }
    
    func setImage(for imageView: UIImageView) -> CancelLoadingHandler? {
        if let weatherIconName = weatherIconName {
            return imageLoader.setImage(for: weatherIconName) { imageData in
                if let imageData = imageData {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
        }
        return nil
    }
}
