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
    private let isSpecialLocationThreshold: Int = 10
    
    func sortBySpecialDays(photos: PHFetchResult<PHAsset>) {
        var daysList: [PhotosByDay] = []
        photos.enumerateObjects { photo, index, _ in
            if let date: String = photo.creationDate?.yearMonthDayString() {
                if let byDay = daysList.first(where: { $0.date == date }) {
                    byDay.add(photo: photo)
                } else {
                    let newPhotosDay = PhotosByDay(date: date)
                    newPhotosDay.add(photo: photo)
                    daysList.append(newPhotosDay)
                }
            }
        }
        
        let specialDays = daysList.filter { $0.count > isSpecialDayThreshold }
        
        specialDays.forEach{ byDay in
            print("Special day found: \(byDay.date) => \(byDay.count)")
        }
    }
    
    func sortBySpecialLocations(photos: PHFetchResult<PHAsset>) {
        var locationList: [PhotosByLocation] = []
        var photoAdded = false
        
        photos.enumerateObjects { photo, index, _ in
            for photosByLocation in locationList {
                if photosByLocation.isNear(photo: photo) {
                    photosByLocation.add(photo: photo)
                    photoAdded = true
                }
            }
            
            if !photoAdded {
                let newPhotosByLocation = PhotosByLocation()
                newPhotosByLocation.add(photo: photo)
                locationList.append(newPhotosByLocation)
            }
            
            photoAdded = false
        }
        
        let specialLocations = locationList.filter { $0.count > isSpecialLocationThreshold }
        
        specialLocations.forEach{ byLocation in
            if let firstLocation = byLocation.photos.first?.location?.coordinate {
                print("Special location found near (lat,lon): \(firstLocation.latitude), \(firstLocation.longitude) => \(byLocation.count)")
            } else {
                print("Error: No first location found")
            }
        }
    }
}

class PhotosByDay {
    var date: String
    var photos: [PHAsset] = []
    var count: Int { photos.count }
    
    init(date: String) {
        self.date = date
    }
    
    func add(photo: PHAsset) { photos.append(photo) }
}

class PhotosByLocation {
    private let nearThreshold: CLLocationDistance = 10_000 // Distance in meters
    
    var photos: [PHAsset] = []
    var count: Int { photos.count }
    
    func isNear(photo: PHAsset) -> Bool {
        guard let photoLocation = photo.location else { return false }
        
        for p in photos {
            if let storedLocation = p.location {
                let distance: CLLocationDistance = photoLocation.distance(from: storedLocation)
                if distance <= nearThreshold {
                    return true
                }
            }
        }
        return false
    }
    
    func add(photo: PHAsset) { photos.append(photo) }
}
