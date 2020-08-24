//
//  URLSession+Extensions.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation
extension URLSession {
    func dataTask(with request: URLRequest, completion: @escaping(Result<Data, Error>) -> Void) -> URLSessionDataTask {
        
        let task = dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            guard 200 ..< 300 ~= response.statusCode else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataCorrupted))
                return
            }
            completion(.success(data))
        }
        
        return task
    }
}
