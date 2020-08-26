//
//  HourlyForecastCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

struct HourlyForecastCellViewModel: AnyTableCellViewModel, WeatherIconImageSetService {
    
    let temperatureDescription: String
    let dateDescription: String
    
    let imageLoader: WeatherIconProvider
    let weatherIconName: String?
    
    init(temperatureDescription: String, dateDescription: String, imageLoader: WeatherIconProvider, weatherIconName: String?) {
        self.temperatureDescription = temperatureDescription
        self.dateDescription = dateDescription
        self.imageLoader = imageLoader
        self.weatherIconName = weatherIconName
    }
    
    func dequeue(tableView: UITableView, for indexPath: IndexPath) -> AnyTableCell {
        return tableView.dequeueReusableCell(withIdentifier: HourlyForecastTableCell.cellIdentifier, for: indexPath) as! HourlyForecastTableCell
    }
}
