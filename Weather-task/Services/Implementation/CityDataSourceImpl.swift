//
//  CityDataSourceImpl.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class CityDataSourceImpl: CityDataSource {
    private let cityProvider: CityProvider
    private let dataSourceDispatchQueue = DispatchQueue(label: "cityDataSource", qos: .userInteractive)
    private var cachedCities = [CityDTO]()
    private var ongoingFiltering: DispatchWorkItem?
    private var previousFiltering: (String, [CityDTO])?
    init(cityProvider: CityProvider) {
        self.cityProvider = cityProvider
    }
    
    func getCities(query: String, completion: @escaping CityLoadingCompletionHandler) {
            dataSourceDispatchQueue.async { [weak self] in
                guard let `self` = self else {
                    completion(.failure(CityProviderError.unknownReason))
                    return
                }
                if self.cachedCities.isEmpty {
                    self.cityProvider.loadCities { result in
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let loadedCities):
                            self.cachedCities = loadedCities
                            let filtered = self.filter(cities: loadedCities, with: query)
                            completion(.success(filtered))
                        }
                    }
                } else {
                    let filtered = self.filter(cities: self.cachedCities, with: query)
                    completion(.success(filtered))
                }
            }
    }
    
    private func filter(cities: [CityDTO], with query: String) -> [CityDTO] {
        guard query.count > 0 else { return [] }
        
        let foldedQuery = query.prepareForSearch()
        if let previousFiltering = self.previousFiltering, query.contains(previousFiltering.0) {
            let filtered = performFilter(for: foldedQuery, data: previousFiltering.1)
            self.previousFiltering = (query, filtered)
            return filtered
        }
        
        let filtered = performFilter(for: foldedQuery, data: cities)
        previousFiltering = (query, filtered)
        return filtered
    }
    
    private func performFilter(for query: String, data: [CityDTO]) -> [CityDTO] {
        return data.filter {
            $0.name.prepareForSearch().hasPrefix(query)
        }
    }
}
