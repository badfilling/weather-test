//
//  WeatherIconProvider.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

protocol WeatherIconProvider {
    func setImage(for iconName: String, completion: @escaping (Data?) -> Void) -> CancelLoadingHandler?
}

typealias CancelLoadingHandler = (() -> Void)
