//
//  NetworkWeatherAPIClient.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 23/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class NetworkWeatherAPIClient: WeatherAPIClient {
    enum Endpoint: String {
        case currentWeather = "weather"
        case forecast = "forecast"
    }
    private let basicURL = "http://api.openweathermap.org/data/2.5/"
    private let apiKey = "0f4ccd5a0002cfb986940c83d13eb325"
    
    let session = URLSession.shared
    
    @discardableResult
    func loadForecast(latitude: Double, longitude: Double, completion: @escaping (Result<[WeatherForecast], Error>) -> Void) -> URLSessionDataTask? {
        do {
            let url = try prepareURL(queryParams: [
                "lat": "\(latitude)",
                "lon": "\(longitude)"], endpoint: .forecast)
            return performRequest(for: url) { (result: Result<DetailForecastDTO, Error>) in
                switch result {
                case .success(let dto):
                    do {
                        var forecasts = [WeatherForecast]()
                        for forecastDTO in dto.list ?? [] {
                            forecasts.append(try forecastDTO.convert())
                        }
                        completion(.success(forecasts))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(NetworkError.serverAccessProblem))
        }
        return nil
    }
    
    @discardableResult
    func loadCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) -> URLSessionDataTask? {
        do {
            let url = try prepareURL(queryParams: [
                "lat": "\(latitude)",
                "lon": "\(longitude)"], endpoint: .currentWeather)
            return performRequest(for: url) { (result: Result<CurrentWeatherDTO, Error>) in
                switch result {
                case .success(let dto):
                    do {
                        let weather = try dto.convert()
                        completion(.success(weather))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(NetworkError.serverAccessProblem))
        }
        return nil
    }
    
    private func prepareURL(queryParams: [String: String], endpoint: Endpoint) throws -> URL {
        func basicURLComponent() -> URLComponents? {
            return URLComponents(string: basicURL + endpoint.rawValue)
        }
        
        func basicQueryItems() -> [URLQueryItem] {
            return [
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        }
        
        var urlComponents = basicURLComponent()
        var queryItems = basicQueryItems()
        for (key, param) in queryParams {
            queryItems.append(URLQueryItem(name: key, value: param))
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            throw NetworkError.serverAccessProblem
        }
        return url
        
    }
    
    private func performRequest<Object: Decodable>(for url: URL, completion: @escaping (Result<Object, Error>) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(Object.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
        return task
    }
}
