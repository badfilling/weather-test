//
//  CityDataSourceMock.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import Weather_task
class CityDataSourceMock: CityDataSource {
    var calledTimes = 0
    var error: Error? = nil
    var cities: [CityDTO]? = nil
    func getCities(query: String, completion: @escaping CityLoadingCompletionHandler) {
        calledTimes += 1
        if cities != nil {
            completion(.success(cities!))
        } else if error != nil {
            completion(.failure(error!))
        }
    }
}
