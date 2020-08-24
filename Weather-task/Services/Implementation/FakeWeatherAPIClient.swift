//
//  FakeWeatherAPIClient.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class FakeWeatherAPIClient: WeatherAPIClient {
    
    let json = """
{"coord":{"lon":30.73,"lat":46.48},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":25,"feels_like":23.02,"temp_min":25,"temp_max":25,"pressure":1013,"humidity":53},"visibility":10000,"wind":{"speed":5,"deg":140},"clouds":{"all":0},"dt":1598280941,"sys":{"type":1,"id":8915,"country":"UA","sunrise":1598238446,"sunset":1598287905},"timezone":10800,"id":698740,"name":"Odesa","cod":200}
"""
    func loadCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) -> URLSessionDataTask? {
        let decoder = JSONDecoder()
        do {
            let data = json.data(using: .utf8)
            let dto = try decoder.decode(CurrentWeatherDTO.self, from: data!)
            let weather = try dto.convert()
            completion(.success(weather))
        } catch {
            completion(.failure(error))
        }
        return nil
    }
}
