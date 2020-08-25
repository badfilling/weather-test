//
//  BasicWeatherCellViewModel.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class BasicWeatherCellViewModel: AnyTableCellViewModel {
    
    let temperatureDescription: String
    let titleDescription: String
    let temperatureLabelColor: UIColor
    
    private let imageLoader: WeatherIconProvider
    private let weatherIconName: String?
    
    init(temperatureDescription: String, titleDescription: String, imageLoader: WeatherIconProvider, weatherIconName: String?, temperatureLabelColor: UIColor) {
        self.temperatureDescription = temperatureDescription
        self.titleDescription = titleDescription
        self.imageLoader = imageLoader
        self.weatherIconName = weatherIconName
        self.temperatureLabelColor = temperatureLabelColor
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
        return tableView.dequeueReusableCell(withIdentifier: BasicWeatherDataCell.cellIdentifier, for: indexPath) as! BasicWeatherDataCell
    }
}
