//
//  RecentlyViewedCitiesProvider.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

protocol RecentlyViewedCitiesProvider {
    func storeAsRecentlyViewed(location: LocationWeatherData)
    func loadRecentlyViewed(completion: @escaping ([LocationWeatherData]) -> Void)
    func removeFromRecentlyViewed(location: LocationWeatherData)
}
