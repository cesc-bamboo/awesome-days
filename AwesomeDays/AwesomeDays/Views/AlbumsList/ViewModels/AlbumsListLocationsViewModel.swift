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
        return self.photosSorter.sortBySpecialLocations(photos: self.photosFetcher.allPhotos)
    }
}
