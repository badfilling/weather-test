//
//  CLLocationService.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 26/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import CoreLocation

class CLLocationService: NSObject, LocationService {
    private let locationManager: CLLocationManager
    private var locationRequest: ((Result<CLLocation, Error>) -> Void)?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func getUserLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        if locationManager.delegate == nil {
            setupManager()
        }
        locationRequest = completion
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            completion(.failure(LocationError.accessDenied))
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            fatalError()
        }
        
    }
    
    private func setupManager() {
        locationManager.delegate = self
    }
}

extension CLLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationRequest?(.failure(error))
        locationRequest = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationRequest?(.success(location))
        }
        locationRequest = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            locationRequest?(.failure(LocationError.accessDenied))
            locationRequest = nil
        }
    }
}
