//
//  LocationInputValidator.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 27/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
protocol LocationInputValidator {
    func convertToCoordinates(latitudeText: String?, longitudeText: String?) throws -> Coordinates
}
