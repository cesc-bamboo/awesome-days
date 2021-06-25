//
//  AlbumCellViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 25/6/21.
//

import Foundation
import SwiftUI
import Photos

class AlbumCellTripsViewModel: ObservableObject {
    let photosByDay: [PhotosByDay]
    let tripTitle: String
    let photosFetcher: PhotosFetcher
    let parentViewSize: CGSize
    
    init(photosByDay: [PhotosByDay], tripTitle: String, photosFetcher: PhotosFetcher, parentViewSize: CGSize) {
        self.photosByDay = photosByDay
        self.tripTitle = tripTitle
        self.photosFetcher = photosFetcher
        self.parentViewSize = parentViewSize
    }
    
    var coverAsset: PHAsset? { photosByDay.first?.photos.first }
    
    func instantiateView() -> some View {
        AlbumTripCell(viewModel: self)
    }
}
