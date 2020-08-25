//
//  FileCityProviderTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
@testable import Weather_task

class FileCityProviderTests: XCTestCase {

    var fileProvider: FileCityProvider!
    var bundle: Bundle!
    var testDataResourceName: String!
    override func setUpWithError() throws {
        testDataResourceName = "testCities"
        bundle = Bundle(for: type(of: self))
        fileProvider = FileCityProvider(bundle: bundle, resourceName: testDataResourceName)
    }

    override func tearDownWithError() throws {
    }
    
    func testCitiesLoadedFromFile() {
        let exp = expectation(description: "loaded 2 cities")
        fileProvider.loadCities { result in
            switch result {
            case .failure(_):
                break
            case .success(let dtos):
                if dtos.count == 2 {
                    exp.fulfill()
                }
            }
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func testConsequentLoadingsProcessed() {
        let exp1 = expectation(description: "loaded cities first time")
        var firstExpFulfilled = false
        let exp2 = expectation(description: "loaded cities second time")
        fileProvider.loadCities { result in
            switch result {
            case .failure(let error):
                print(error)
                break
            case .success(let dtos):
                if dtos.count == 2 {
                    exp1.fulfill()
                    firstExpFulfilled = true
                }
            }
        }
        fileProvider.loadCities { result in
            switch result {
            case .failure(_):
                break
            case .success(_):
                if firstExpFulfilled {
                    exp2.fulfill()
                }
            }
        }
        wait(for: [exp1, exp2], timeout: 0.5)
    }
    
    func testErrorOnWrongFile() {
        testDataResourceName = "random"
        let errorExpectation = expectation(description: "error on file reading")
        fileProvider = FileCityProvider(bundle: bundle, resourceName: testDataResourceName)
        fileProvider.loadCities { result in
            switch result {
            case .failure(let error):
                if case CityProviderError.fileReadingProblem = error {
                    errorExpectation.fulfill()
                }
            case .success(_):
                break
            }
        }
        wait(for: [errorExpectation], timeout: 0.1)
    }
}

