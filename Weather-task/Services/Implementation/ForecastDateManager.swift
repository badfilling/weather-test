//
//  ForecastDateManager.swift
//  Weather-task
//
//  Created by Artur Stepaniuk on 24/08/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import Foundation

class ForecastDateManager {
    let UTCformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    let currentTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h a"
        return formatter
    }()
    
    let calendar = Calendar.current
    
    func isToday(utc: String) -> Bool {
        guard let currentDate = UTCformatter.date(from: utc) else { return false }
        return calendar.isDateInToday(currentDate)
    }
    
    func hours(of time: String) -> String {
        guard let utc = UTCformatter.date(from: time) else { return "" }
        return currentTimeFormatter.string(from: utc)
    }
    
    func dayWithTime(utc: String) -> String? {
        guard let currentDate = UTCformatter.date(from: utc) else { return nil }
        let dayOfWeek = calendar.weekdaySymbols[calendar.component(.weekday, from: currentDate) - 1]
        
        let hoursDescription = hours(of: utc)
        return "\(dayOfWeek),\n\(hoursDescription)"
    }
}
