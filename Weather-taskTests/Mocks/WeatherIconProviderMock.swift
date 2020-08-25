//
//  WeatherIconProviderMock.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
@testable import Weather_task
class WeatherIconProviderMock: WeatherIconProvider {
    var calledForIcon: String? = nil
    var dataToReturn: Data?
    
    func setImage(for iconName: String, completion: @escaping (Data?) -> Void) -> CancelLoadingHandler? {
        calledForIcon = iconName
        completion(dataToReturn)
        return nil
    }
    
    
}
