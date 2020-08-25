//
//  CityProviderMock.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import Weather_task

class CityProviderMock: CityProvider {
    var cities = [CityDTO]()
    var error: Error? = nil
    func loadCities(completion: @escaping CityLoadingCompletionHandler) {
        if error == nil {
            completion(.success(cities))
        } else {
            completion(.failure(error!))
        }
    }
}
