//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI
import Photos

class AlbumsListDaysViewModel: AlbumsListViewModelDefault<PhotosByDay> {
    override func photosToPresent() -> [PhotosByDay] {
        if let photos = photosAlreadySorted {
            return photos
        } else {
            let specialDaysPhotos = self.photosSorter.sortBySpecialDays(photos: self.photosFetcher.allPhotos)
            photosAlreadySorted = specialDaysPhotos.isEmpty ? nil : specialDaysPhotos
            return specialDaysPhotos
        }
    }
}
