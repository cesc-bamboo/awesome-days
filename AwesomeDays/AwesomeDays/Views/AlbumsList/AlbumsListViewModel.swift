//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI
import Photos

class AlbumsListViewModel: ObservableObject {
    private let photosFetcher: PhotosFetcher
    private let photosSorter: PhotosSorter
    
    @Published var allPhotos = PHFetchResult<PHAsset>()
    @Published var smartAlbums = PHFetchResult<PHAssetCollection>()
    @Published var userCollections = PHFetchResult<PHAssetCollection>()
    
    init(photosFetcher: PhotosFetcher = PhotosFetcher(), photosSorter: PhotosSorter = PhotosSorter()) {
        self.photosFetcher = photosFetcher
        self.photosSorter = photosSorter
    }
    
    func fetchPhotosAskingPermission() {
        photosFetcher.getPermissionIfNecessary { granted in
            guard granted else { return }
            self.photosFetcher.fetchAssets()
            DispatchQueue.main.async {
                self.allPhotos = self.photosFetcher.allPhotos
                self.smartAlbums = self.photosFetcher.smartAlbums
                self.userCollections = self.photosFetcher.userCollections
                
                // TEST!
                self.photosSorter.sortBySpecialDays(photos: self.allPhotos)
            }
        }
    }
    
    func instantiateView() -> some View {
        AlbumsListView(viewModel: self)
    }
}
