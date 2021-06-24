//
//  PhotosByLocation.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 24/6/21.
//

import Foundation
import Photos

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
