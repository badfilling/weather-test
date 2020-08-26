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

enum LocationError: Error {
    case accessDenied
}
