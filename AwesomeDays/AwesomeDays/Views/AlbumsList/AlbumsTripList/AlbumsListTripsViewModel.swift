//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI
import Photos

class AlbumsListTripsViewModel: AlbumsListViewModelDefault<PhotosByDay> {
    override func photosToPresent() -> [PhotosByDay] {
//        self.photosSorter.sortBySpecialDays(photos: self.photosFetcher.allPhotos)
        return []
    }
    
    func tripsToPresent() -> [PhotosByTrip] {
        self.photosSorter.sortBySpecialTrips(photos: self.photosFetcher.allPhotos, ordered: .descending)
    }
    
    func instantiateView() -> some View {
        AlbumsListTripView(viewModel: self)
    }
}
