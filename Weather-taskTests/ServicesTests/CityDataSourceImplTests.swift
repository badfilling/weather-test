//
//  CityDataSourceImplTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
@testable import Weather_task

class CityDataSourceImplTests: XCTestCase {

    var dataSource: CityDataSourceImpl!
    var cityProvider: CityProviderMock!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cityProvider = CityProviderMock()
        dataSource = CityDataSourceImpl(cityProvider: cityProvider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReturnsEmptyListWhenNoCities() {
        let exp = expectation(description: "success, empty return")
        dataSource.getCities(query: "") { result in
            switch result {
            case .failure(_):
                break
            case .success(let dtos):
                if dtos.isEmpty {
                    exp.fulfill()
                }
            }
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func testReturnsErrorOnProviderError() {
        cityProvider.error = CityProviderError.unknownReason
        let exp = expectation(description: "returned with error")
        dataSource.getCities(query: "") { result in
            switch result {
            case .failure(_):
                exp.fulfill()
            case .success(_):
                break
            }
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func testFindsCitiesByQueryCorrectly() {
        let query = "Zam"
        let cities = [prepareCity(name: "Zamecity"), prepareCity(name: "Othercity")]
        cityProvider.cities = cities
        
        let exp = expectation(description: "city found")
        dataSource.getCities(query: query) { result in
            switch result {
            case .failure(_):
                break
            case .success(let dtos):
                if dtos.contains(cities[0]) {
                    exp.fulfill()
                }
            }
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func prepareCity(name: String) -> CityDTO {
        return CityDTO(id: 0, name: name, countryCode: nil, coordinates: Coordinates(latitude: 0, longitude: 0))
    }
}
