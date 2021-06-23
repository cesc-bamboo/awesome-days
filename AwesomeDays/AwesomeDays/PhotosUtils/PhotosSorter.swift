//
//  PhotosSorter.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import Photos

class PhotosSorter {
    private let isSpecialDayThreshold: Int = 4
    
    func sortBySpecialDays(photos: PHFetchResult<PHAsset>) {
        var photosByDay: [String : Int] = [:]
        photos.enumerateObjects { photo, index, _ in
            if let date: String = photo.creationDate?.yearMonthDayString() {
                let counter = photosByDay[date] ?? 0
                photosByDay[date] = counter + 1
            }
        }
        
        let specialDays = photosByDay.filter { (key, value) in
            value > isSpecialDayThreshold
        }
        
        specialDays.forEach{ (key, value) in
            print("Special day found: \(key) => \(value)")
        }
    }
}
