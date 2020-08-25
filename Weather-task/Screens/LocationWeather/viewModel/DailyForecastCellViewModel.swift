//
//  DailyForecastCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class DailyForecastCellViewModel: AnyTableCellViewModel, WeatherIconImageSetService {
    
    let minTemperatureDescription: String
    let maxTemperatureDescription: String
    let dateDescription: String
    
    let imageLoader: WeatherIconProvider
    let weatherIconName: String?
    
    init(minTemperatureDescription: String, maxTemperatureDescription: String, dateDescription: String, imageLoader: WeatherIconProvider, weatherIconName: String?) {
        self.minTemperatureDescription = minTemperatureDescription
        self.maxTemperatureDescription = maxTemperatureDescription
        self.dateDescription = dateDescription
        self.imageLoader = imageLoader
        self.weatherIconName = weatherIconName
    }
    
    func dequeue(tableView: UITableView, for indexPath: IndexPath) -> AnyTableCell {
        return tableView.dequeueReusableCell(withIdentifier: DailyForecastTableCell.cellIdentifier, for: indexPath) as! DailyForecastTableCell
    }
}
