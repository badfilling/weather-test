//
//  LocationServiceMock.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 26/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import CoreLocation
@testable import Weather_task

class LocationServiceMock: LocationService {
    var getLocationCalledTimes = 0
    func getUserLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        getLocationCalledTimes += 1
    }
    
    
}
