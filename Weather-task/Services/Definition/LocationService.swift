//
//  LocationService.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 26/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationService {
    func getUserLocation(completion: @escaping (Result<CLLocation, Error>) -> Void)
}

enum LocationError: Error, LocalizedError {
    case accessDenied
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Location access is disabled. Change it in app settings"
        }
    }
}
