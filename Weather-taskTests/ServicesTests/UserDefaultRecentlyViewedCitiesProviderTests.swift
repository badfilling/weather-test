//
//  UserDefaultRecentlyViewedCitiesProviderTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
@testable import Weather_task
class UserDefaultRecentlyViewedCitiesProviderTests: XCTestCase {

    var userDefaults: UserDefaults!
    var recentlyViewedProvider: UserDefaultsRecentlyViewedCitiesProvider!
    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        recentlyViewedProvider = UserDefaultsRecentlyViewedCitiesProvider(userDefaults: userDefaults)
    }

    override func tearDownWithError() throws {
        userDefaults.removePersistentDomain(forName: #file)
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLocationIsAddedAndReceived() {
        let uuid = UUID()
        let location = prepareLocation(with: uuid)
        recentlyViewedProvider.storeAsRecentlyViewed(location: location)
        let exp = expectation(description: "location saved and retreived")
        
        recentlyViewedProvider.loadRecentlyViewed { locations in
            if locations.count == 1 && locations.contains(location) {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testPreviosLocationIsNotDeletedOnAddingNew() {
        let uuid1 = UUID()
        let location1 = prepareLocation(with: uuid1)
        let uuid2 = UUID()
        let location2 = prepareLocation(with: uuid2)
        recentlyViewedProvider.storeAsRecentlyViewed(location: location1)
        recentlyViewedProvider.storeAsRecentlyViewed(location: location2)
        let exp = expectation(description: "both locations present")
        
        recentlyViewedProvider.loadRecentlyViewed { locations in
            if locations.count == 2 && locations.contains(location1) && locations.contains(location2) {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testLocationIsRemoved() {
        let uuid = UUID()
        let location = prepareLocation(with: uuid)
        let exp = expectation(description: "location deleted")
        
        recentlyViewedProvider.storeAsRecentlyViewed(location: location)
        recentlyViewedProvider.removeFromRecentlyViewed(location: location)
        
        recentlyViewedProvider.loadRecentlyViewed { locations in
            if locations.count == 0 {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    private func prepareLocation(with uuid: UUID) -> LocationWeatherData {
        return LocationWeatherData(uuid: uuid, cityId: nil, cityName: nil, cityCoordinates: Coordinates(latitude: 0, longitude: 0), countryCode: nil, currentWeather: nil, forecastTimestamp: nil)
    }
}
