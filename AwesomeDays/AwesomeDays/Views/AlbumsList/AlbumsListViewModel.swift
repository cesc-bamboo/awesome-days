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
    var photosFetcher: PhotosFetcher
    @Published var allPhotos = PHFetchResult<PHAsset>()
    @Published var smartAlbums = PHFetchResult<PHAssetCollection>()
    @Published var userCollections = PHFetchResult<PHAssetCollection>()
    
    init(photosFetcher: PhotosFetcher = PhotosFetcher()) {
        self.photosFetcher = photosFetcher
    }
    
    func fetchPhotosAskingPermission() {
        photosFetcher.getPermissionIfNecessary { granted in
          guard granted else { return }
            self.photosFetcher.fetchAssets()
            self.allPhotos = self.photosFetcher.allPhotos
            self.smartAlbums = self.photosFetcher.smartAlbums
            self.userCollections = self.photosFetcher.userCollections
        }
    }
    
    func instantiateView() -> some View {
        AlbumsListView(viewModel: self)
    }
}
