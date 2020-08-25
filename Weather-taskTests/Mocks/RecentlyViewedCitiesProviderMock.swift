//
//  File.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import Weather_task
class RecentlyViewedCitiesProviderMock: RecentlyViewedCitiesProvider {
    var storedCities = [LocationWeatherData]()
    
    var removeCalledTimes = 0
    var loadCalledTimes = 0
    var storeCalledtimes = 0
    func storeAsRecentlyViewed(location: LocationWeatherData) {
        storeCalledtimes += 1
    }
    
    func loadRecentlyViewed(completion: @escaping ([LocationWeatherData]) -> Void) {
        completion(self.storedCities)
        loadCalledTimes += 1
    }
    
    func removeFromRecentlyViewed(location: LocationWeatherData) {
        removeCalledTimes += 1
    }
    
    
}
