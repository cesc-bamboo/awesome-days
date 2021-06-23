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
}
