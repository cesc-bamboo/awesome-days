//
//  PhotosByTrip.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 24/6/21.
//

import Foundation
import Photos

class PhotosByTrip: PhotosByProtocol {
    var photos: [PHAsset] = []
    
    var photosByDays: [PhotosByDay] = []
    var count: Int { photosByDays.count }
    var uuid: UUID = UUID()
    
//    var photos: [PHAsset] {
//        photosByDays.reduce([]) { partialResult, byDay in
//            return partialResult + byDay.photos
//        }
//    }
    
    var description: String {
        guard let firstDate = photosByDays.first?.date,
              let lastDate = photosByDays.last?.date else { return "No dates" }
        
        return "\(firstDate) to \(lastDate)"
    }
    
    func isInThisTrip(photos: PhotosByDay) -> Bool {
        if photosByDays.isEmpty { return true }
        
        guard let photosDate = photos.dateFormatted else { return false }
        
        for byDay in photosByDays {
            if let dayDate = byDay.dateFormatted,
               dayDate.isNearDay(date: photosDate, daysDistanceAllowed: 1) {
                return true
            }
        }
        return false
    }
    
    func add(photos: PhotosByDay) { photosByDays.append(photos) }
}
