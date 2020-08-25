//
//  WeatherConditionDTO.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
struct WeatherConditionDTO: Decodable {
    let description: String?
    let icon: String?
}
