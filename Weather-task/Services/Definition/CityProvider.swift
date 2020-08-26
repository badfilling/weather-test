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

enum CityProviderError: Error, LocalizedError {
    case fileReadingProblem
    case unknownReason
    
    var errorDescription: String? {
        switch self {
        case .fileReadingProblem:
            return "Problem with reading saved cities from file"
        case .unknownReason:
            return "Unknown system error"
        }
    }
}

typealias CityLoadingCompletionHandler = ((Result<[CityDTO], Error>) -> Void)
