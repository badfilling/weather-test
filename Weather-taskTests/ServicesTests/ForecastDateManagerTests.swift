//
//  ForecastDateManagerTests.swift
//  Weather-taskTests
//
//  Created by Artur Stepaniuk on 25/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import XCTest
@testable import Weather_task
class ForecastDateManagerTests: XCTestCase {

    var dateManager: ForecastDateManager!
    var calendar: Calendar!
    override func setUpWithError() throws {
        calendar = Calendar.current
        dateManager = ForecastDateManager(calendar: calendar)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTodayIsCheckedCorrectly() {
        let today = Date()
        
        XCTAssertTrue(dateManager.isToday(utc: toUTCFormat(date: today)))
    }
    
    func testHoursGotCorrectly() {
        let datePM_UTC = "2020-01-01 13:00:00"
        let dateAM_UTC = "2020-01-01 11:00:00"
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        dateManager = ForecastDateManager(calendar: calendar)
        
        XCTAssertEqual(dateManager.hours(utc: datePM_UTC), "1 PM")
        XCTAssertEqual(dateManager.hours(utc: dateAM_UTC), "11 AM")
    }
    
    func testDayWithHourGotCorrectly() {
        let date_UTC = "2020-08-24 13:00:00"
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        dateManager = ForecastDateManager(calendar: calendar)
        
        let expected = "Monday,\n1 PM"
        
        XCTAssertEqual(dateManager.dayWithTime(utc: date_UTC), expected)
    }
    
    private func toUTCFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: date)
    }
}
