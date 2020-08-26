//
//  LocationDelegateMock.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import Weather_task

class LocationDelegateMock: AddLocationDelegate {
    func addedCoordinates(latitude: Double, longitude: Double) {
        
    }
    
    var calledTimes = 0
    func added(location: LocationWeatherData) {
        calledTimes += 1
    }
}
