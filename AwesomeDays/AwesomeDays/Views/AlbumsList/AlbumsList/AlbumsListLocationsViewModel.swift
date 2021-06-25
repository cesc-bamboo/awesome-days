//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI
import Photos

class AlbumsListLocationsViewModel: AlbumsListViewModelDefault<PhotosByLocation> {
    override func photosToPresent() -> [PhotosByLocation] {
        if let photos = photosAlreadySorted {
            return photos
        } else {
            let specialLocationPhotos = self.photosSorter.sortBySpecialLocations(photos: self.photosFetcher.allPhotos)
            photosAlreadySorted = specialLocationPhotos.isEmpty ? nil : specialLocationPhotos
            return specialLocationPhotos
        }
    }
}
