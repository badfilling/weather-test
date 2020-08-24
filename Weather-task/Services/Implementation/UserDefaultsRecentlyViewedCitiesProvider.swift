//
//  UserDefaultsRecentlyViewedCitiesProvider.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class UserDefaultsRecentlyViewedCitiesProvider: RecentlyViewedCitiesProvider {
    
    private let userDefaults: UserDefaults
    private let recentlyViewedLocations = "recentlyViewedLocations"
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func storeAsRecentlyViewed(location: LocationWeatherData) {
        if var locations: [LocationWeatherData] = getValue(for: recentlyViewedLocations) {
            locations.append(location)
            save(value: locations, key: recentlyViewedLocations)
        } else {
            save(value: [location], key: recentlyViewedLocations)
        }
    }
    
    func loadRecentlyViewed(completion: @escaping ([LocationWeatherData]) -> Void) {
        if let stored: [LocationWeatherData] = getValue(for: recentlyViewedLocations) {
            completion(stored)
        } else {
            completion([])
        }
    }
    
    func removeFromRecentlyViewed(location: LocationWeatherData) {
        if var stored: [LocationWeatherData] = getValue(for: recentlyViewedLocations) {
            stored.removeAll { location == $0 }
            save(value: stored, key: recentlyViewedLocations)
        }
    }
    
    private func save<T: Codable>(value: T, key: String) {
        let encoded = try? encoder.encode(value)
        userDefaults.set(encoded, forKey: key)
    }
    
    private func getValue<T: Codable> (for key: String) -> T? {
        if let raw = userDefaults.value(forKey: key) as? Data {
            return try? decoder.decode(T.self, from: raw)
        }
        return nil
    }
    
}
