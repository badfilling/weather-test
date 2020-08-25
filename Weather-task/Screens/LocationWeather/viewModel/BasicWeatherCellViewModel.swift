//
//  BasicWeatherCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class BasicWeatherCellViewModel: AnyTableCellViewModel, WeatherIconImageSetService {
    
    let temperatureDescription: String
    let titleDescription: String
    let temperatureLabelColor: UIColor
    
    let imageLoader: WeatherIconProvider
    let weatherIconName: String?
    
    init(temperatureDescription: String, titleDescription: String, imageLoader: WeatherIconProvider, weatherIconName: String?, temperatureLabelColor: UIColor) {
        self.temperatureDescription = temperatureDescription
        self.titleDescription = titleDescription
        self.imageLoader = imageLoader
        self.weatherIconName = weatherIconName
        self.temperatureLabelColor = temperatureLabelColor
    }
    
    func dequeue(tableView: UITableView, for indexPath: IndexPath) -> AnyTableCell {
        return tableView.dequeueReusableCell(withIdentifier: BasicWeatherDataCell.cellIdentifier, for: indexPath) as! BasicWeatherDataCell
    }
}
