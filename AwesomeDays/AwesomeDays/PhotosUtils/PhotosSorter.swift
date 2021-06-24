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
    private let isSpecialTripThreshold: Int = 2
    
    func sortBySpecialDays(photos: PHFetchResult<PHAsset>) -> [PhotosByDay] {
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
        
        let specialDays: [PhotosByDay] = daysList.filter { $0.count > isSpecialDayThreshold }
        
        specialDays.forEach{ byDay in
            print("Special day found: \(byDay.date) => \(byDay.count)")
        }
        return specialDays
    }
    
    func sortBySpecialLocations(photos: PHFetchResult<PHAsset>) -> [PhotosByLocation] {
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
        
        let specialLocations: [PhotosByLocation] = locationList.filter { $0.count > isSpecialLocationThreshold }
        
        specialLocations.forEach{ byLocation in
            if let firstLocation = byLocation.photos.first?.location?.coordinate {
                print("Special location found near (lat,lon): \(firstLocation.latitude), \(firstLocation.longitude) => \(byLocation.count)")
            } else {
                print("Error: No first location found")
            }
        }
        return specialLocations
    }
    
    func sortBySpecialTrips(photos: PHFetchResult<PHAsset>) -> [PhotosByTrip] {
        let specialDays = sortBySpecialDays(photos: photos)
        let sortedDays = specialDays.sorted { $0.date < $1.date }
        
        var trips: [PhotosByTrip] = []
        
        var currentTrip = PhotosByTrip()
        for byDay in sortedDays {
            if currentTrip.isInThisTrip(photos: byDay) {
                currentTrip.add(photos: byDay)
            } else {
                if currentTrip.count >= isSpecialTripThreshold {
                    trips.append(currentTrip)
                }
                currentTrip = PhotosByTrip()
                currentTrip.add(photos: byDay)
            }
        }
        
        if currentTrip.count >= isSpecialTripThreshold {
            trips.append(currentTrip)
        }
        
        trips.forEach{ trip in
            print(trip.description)
        }
        
        return trips
    }
}

class PhotosByDay: CustomStringConvertible {
    // We could store a 'date: Date' here, but it's EXTREMELY slow to copy this struct. We're using a String instead and convert it when necessary.
    var date: String
    var photos: [PHAsset] = []
    var count: Int { photos.count }
    
    var description: String {
        return "Photos by Day \(date) => \(count)"
    }
    
    init(date: String) {
        self.date = date
    }
    
    func add(photo: PHAsset) { photos.append(photo) }
}

class PhotosByLocation: CustomStringConvertible {
    private let nearThreshold: CLLocationDistance = 10_000 // Distance in meters
    
    var photos: [PHAsset] = []
    var count: Int { photos.count }
    
    var description: String {
        if let firstLocation = photos.first?.location?.coordinate {
            return "Photos by Location near (lat,lon): \(firstLocation.latitude), \(firstLocation.longitude) => \(count)"
        } else {
            return "Error: first location not found"
        }
    }
    
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
