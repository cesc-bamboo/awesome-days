//
//  DateExtension.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation

extension Date {
    func yearMonthDayString() -> String {
        let yearMonthDayFormatter = DateFormatter()
        yearMonthDayFormatter.dateFormat = "y-MM-d"
        return yearMonthDayFormatter.string(from: self)
    }
    
    static func fromYearMonthDayString(stringDate: String) -> Date? {
        let yearMonthDayFormatter = DateFormatter()
        yearMonthDayFormatter.dateFormat = "y-MM-d"
        return yearMonthDayFormatter.date(from: stringDate)
    }
    
    func isNearDay(date: Date, daysDistanceAllowed: Int = 1) -> Bool {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let newDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        guard let currentDay = currentDateComponents.day, let newDay = newDateComponents.day else { return false }
        
        if currentDateComponents.year == newDateComponents.year
            && currentDateComponents.month == newDateComponents.month {
            let minDayAllowed = currentDay - daysDistanceAllowed
            let maxDayAllowed = currentDay + daysDistanceAllowed
            
            if newDay >= minDayAllowed && newDay <= maxDayAllowed {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
