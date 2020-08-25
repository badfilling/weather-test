//
//  WeatherIconImageSetService.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

protocol WeatherIconImageSetService {
    var weatherIconName: String? { get }
    var imageLoader: WeatherIconProvider { get }
    func setImage(for imageView: UIImageView) -> CancelLoadingHandler?
}

extension WeatherIconImageSetService {
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
