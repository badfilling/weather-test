//
//  CoordinatesInputValidatorTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 27/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
@testable import Weather_task
class CoordinatesInputValidatorTests: XCTestCase {

    var validator: CoordinatesInputValidator!
    override func setUpWithError() throws {
        validator = CoordinatesInputValidator()
    }
    
    func testNilInputProducesError() {
        XCTAssertThrowsError(try validator.convertToCoordinates(latitudeText: nil, longitudeText: nil))
    }
    
    func testEmptyInputProducesError() {
        XCTAssertThrowsError(try validator.convertToCoordinates(latitudeText: "", longitudeText: ""))
    }
    
    func testNonDigitsProduceError() {
        XCTAssertThrowsError(try validator.convertToCoordinates(latitudeText: "random", longitudeText: "random"))
    }
    
    func testInputWithDoublesWithCommasIsAccepted() {
        let coordinates = Coordinates(latitude: 2.0, longitude: 2.0)
        
        XCTAssertEqual(coordinates, try validator.convertToCoordinates(latitudeText: "2,0", longitudeText: "2,0"))
    }
    
    func testCorretInputIsAccepted() {
        let coordinates = Coordinates(latitude: 2.0, longitude: 2.0)
        
        XCTAssertEqual(coordinates, try validator.convertToCoordinates(latitudeText: "2", longitudeText: "2"))
    }
}
