//
//  AppDelegate.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 21/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        
        let recentCitiesProvider = UserDefaultsRecentlyViewedCitiesProvider()
//        let weatherProvider = NetworkWeatherAPIClient()
        let weatherProvider = FakeWeatherAPIClient()
        let iconProvider = NetworkWeatherIconProvider(scale: Int(UIScreen.main.scale))
        let citiesVM = RecentLocationsViewModel(recentCitiesProvider: recentCitiesProvider, weatherProvider: weatherProvider, iconProvider: iconProvider)
        let cityProvider = FileCityProvider()
        let citiesVC = RecentLocationsViewController(viewModel: citiesVM, cityProvider: cityProvider)
        let navigation = UINavigationController(rootViewController: citiesVC)
        window?.rootViewController = navigation
        
        window?.makeKeyAndVisible()
        return true
    }
}

