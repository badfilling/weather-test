//
//  DetailForecastDTO.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct DetailForecastDTO: Decodable {
    let list: [DetailForecastDataDTO]?
}
