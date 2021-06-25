//
//  PhotosByDay.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 24/6/21.
//

import Foundation
import Photos

class PhotosByDay: PhotosByProtocol {
    // We could store a 'date: Date' here, but it's EXTREMELY slow to copy this struct. We're using a String instead and convert it when necessary.
    var date: String
    var photos: [PHAsset] = []
    var count: Int { photos.count }
    var uuid: UUID = UUID()
    
    var description: String {
        return "Photos by Day \(date) => \(count)"
    }
    
    init(date: String) {
        self.date = date
    }
    
    func add(photo: PHAsset) { photos.append(photo) }
}
