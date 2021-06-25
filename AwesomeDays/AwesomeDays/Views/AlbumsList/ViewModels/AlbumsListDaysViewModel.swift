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
        return self.photosSorter.sortBySpecialDays(photos: self.photosFetcher.allPhotos)
    }
}
