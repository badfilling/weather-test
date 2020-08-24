//
//  CityProvider.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 21/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

protocol CityProvider {
    func loadCities(completion: @escaping CityLoadingCompletionHandler)
}

enum CityProviderError: Error {
    case fileReadingProblem
    case unknownReason
}

typealias CityLoadingCompletionHandler = ((Result<[CityDTO], Error>) -> Void)
