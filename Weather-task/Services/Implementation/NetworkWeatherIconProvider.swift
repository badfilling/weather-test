//
//  NetworkWeatherIconProvider.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
import UIKit

struct NetworkWeatherIconProvider: WeatherIconProvider {
    private let cache = NSCache<NSString, NSData>()
    private let basicURL = "http://openweathermap.org/img/wn/"
    private let session: URLSession
    private let scale: Int = 2
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    func setImage(for iconName: String, completion: @escaping (Data?) -> Void) -> CancelLoadingHandler? {
        if let cached = cache.object(forKey: iconName as NSString) {
            completion(cached as Data)
            return nil
        }
        
        guard let url = URL(string: (basicURL + iconName + "@\(scale)x.png")) else {
            completion(nil)
            return nil
        }
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { result in
            switch result {
            case .failure(_):
                completion(nil)
            case .success(let data):
                self.cache.setObject(data as NSData, forKey: iconName as NSString)
                completion(data)
            }
        }
        task.resume()
        return { task.cancel() }
    }
}
