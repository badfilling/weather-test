//
//  CityDataSource.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 22/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

protocol CityDataSource {
    func getCities(query: String, completion: @escaping CityLoadingCompletionHandler)
}
