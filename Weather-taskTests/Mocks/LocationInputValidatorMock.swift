//
//  LocationInputValidatorMock.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 27/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import Weather_task
struct LocationInputValidatorMock: LocationInputValidator {
    var coordinatesToReturn = Coordinates(latitude: 0, longitude: 0)
    func convertToCoordinates(latitudeText: String?, longitudeText: String?) throws -> Coordinates {
        return coordinatesToReturn
    }
}
