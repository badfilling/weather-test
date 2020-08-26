//
//  AppDelegate.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 21/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        
        let recentCitiesProvider = UserDefaultsRecentlyViewedCitiesProvider()
        var weatherProvider: WeatherAPIClient!
        if (ProcessInfo.processInfo.environment["ENV"] ?? "") == "DEV" {
            weatherProvider = FakeWeatherAPIClient()
        } else {
            weatherProvider = NetworkWeatherAPIClient()
        }
        let iconProvider = NetworkWeatherIconProvider()
        let locationService = CLLocationService(locationManager: CLLocationManager())
        let cityProvider = FileCityProvider(bundle: Bundle.main, resourceName: "city.list.min")
        let coordinatesInputValidator = CoordinatesInputValidator()
        let citiesVM = RecentLocationsViewModel(recentCitiesProvider: recentCitiesProvider, weatherProvider: weatherProvider, iconProvider: iconProvider, locationService: locationService, cityProvider: cityProvider, coordinatesInputValidator: coordinatesInputValidator)
        let citiesVC = RecentLocationsViewController(viewModel: citiesVM)
        let navigation = UINavigationController(rootViewController: citiesVC)
        window?.rootViewController = navigation
        
        window?.makeKeyAndVisible()
        return true
    }
}

