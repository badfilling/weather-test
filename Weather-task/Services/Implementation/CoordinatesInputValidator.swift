//
//  CoordinatesInputValidator.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 27/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

struct CoordinatesInputValidator: LocationInputValidator {
    func convertToCoordinates(latitudeText: String?, longitudeText: String?) throws -> Coordinates {
        guard let latitudeText = latitudeText,
            let longitudeText = longitudeText,
            let latitude = Double(latitudeText.replacingOccurrences(of: ",", with: ".")),
            let longitude = Double(longitudeText.replacingOccurrences(of: ",", with: ".")) else {
                throw LocationError.incorrectData
        }
        return Coordinates(latitude: latitude, longitude: longitude)
    }
}
