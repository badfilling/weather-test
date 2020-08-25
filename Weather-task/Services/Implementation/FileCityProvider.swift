//
//  FileCityProvider.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class FileCityProvider: CityProvider {
    private var loadedCities = [CityDTO]()
    private var loadingError: Error?
    private var loadingDispatchTask: DispatchWorkItem?
    private let providerDispatchQueue = DispatchQueue(label: "fileCityProvider", qos: .userInitiated)
    private let resourceType = "json"
    private let bundle: Bundle
    private let resourceName: String
    init(bundle: Bundle, resourceName: String) {
        self.bundle = bundle
        self.resourceName = resourceName
    }
    
    func loadCities(completion: @escaping CityLoadingCompletionHandler) {
        guard loadingDispatchTask == nil else {
            loadingDispatchTask?.notify(queue: providerDispatchQueue) {
                if self.loadingError != nil {
                    completion(.failure(self.loadingError!))
                } else {
                    completion(.success(self.loadedCities))
                }
            }
            return
        }
        
        guard loadingError == nil else {
            completion(.failure(loadingError!))
            return
        }
        
        tryLoadingFromFile(completion: completion)
    }
    
    private func tryLoadingFromFile(completion: CityLoadingCompletionHandler?) {
        guard let path = bundle.path(forResource: resourceName, ofType: resourceType) else {
            loadingError = CityProviderError.fileReadingProblem
            completion?(.failure(loadingError!))
            return
        }
        
        let loadingTask = startFileReadingDispatchItem(filePath: URL(fileURLWithPath: path), completion: completion)
        self.loadingDispatchTask = loadingTask
        providerDispatchQueue.async(execute: loadingTask)
    }
    
    private func startFileReadingDispatchItem(filePath: URL, completion:  CityLoadingCompletionHandler?) -> DispatchWorkItem {
        return DispatchWorkItem { [weak self] in
            do {
                let data = try Data(contentsOf: filePath)
                let decoder = JSONDecoder()
                let cities = try decoder.decode([CityDTO].self, from: data)
                self?.loadedCities = cities
                self?.loadingError = nil
                completion?(.success(cities))
            } catch {
                let error = CityProviderError.fileReadingProblem
                self?.loadingError = error
                completion?(.failure(error))
            }
        }
    }
}
