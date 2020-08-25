//
//  DailyForecastCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class DailyForecastCellViewModel: AnyTableCellViewModel {
    
    let minTemperatureDescription: String
    let maxTemperatureDescription: String
    let dateDescription: String
    
    private let imageLoader: WeatherIconProvider
    private let weatherIconName: String?
    
    init(minTemperatureDescription: String, maxTemperatureDescription: String, dateDescription: String, imageLoader: WeatherIconProvider, weatherIconName: String?) {
        self.minTemperatureDescription = minTemperatureDescription
        self.maxTemperatureDescription = maxTemperatureDescription
        self.dateDescription = dateDescription
        self.imageLoader = imageLoader
        self.weatherIconName = weatherIconName
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
    
    func dequeue(tableView: UITableView, for indexPath: IndexPath) -> AnyTableCell {
        return tableView.dequeueReusableCell(withIdentifier: DailyForecastTableCell.cellIdentifier, for: indexPath) as! DailyForecastTableCell
    }
}