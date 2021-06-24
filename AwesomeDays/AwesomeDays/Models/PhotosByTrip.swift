//
//  PhotosByTrip.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 24/6/21.
//

import Foundation
import Photos

class PhotosByTrip: CustomStringConvertible {
    var photosByDays: [PhotosByDay] = []
    var count: Int { photosByDays.count }
    
    var description: String {
        var tripDesc: String = "Photos by Trip => \(count)"
        for byDay in photosByDays {
            tripDesc += "\n  # \(byDay.description)"
        }
        return tripDesc
    }
    
    func isInThisTrip(photos: PhotosByDay) -> Bool {
        if photosByDays.isEmpty { return true }
        
        guard let photosDate = Date.fromYearMonthDayString(stringDate: photos.date) else { return false }
        
        for byDay in photosByDays {
            if let dayDate = Date.fromYearMonthDayString(stringDate: byDay.date),
               dayDate.isNearDay(date: photosDate, daysDistanceAllowed: 1) {
                return true
            }
        }
        return false
    }
    
    func add(photos: PhotosByDay) { photosByDays.append(photos) }
}
