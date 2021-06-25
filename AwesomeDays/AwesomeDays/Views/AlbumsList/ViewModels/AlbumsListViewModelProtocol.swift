//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI
import Photos

protocol AlbumListViewModelProtocol: ObservableObject {
    associatedtype P: PhotosByProtocol
    func photosToPresent() -> [P]
    
    var photosFetcher: PhotosFetcher { get }
    func fetchPhotosAskingPermission()
}

class AlbumsListViewModelDefault<PhotosByType: PhotosByProtocol>: AlbumListViewModelProtocol {
    let photosFetcher: PhotosFetcher
    let photosSorter: PhotosSorter
    
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
            }
        }
    }
    
    func photosToPresent() -> [PhotosByType] {
        return []
    }
//
//    func allPhotosBySpecialTrips() -> [PhotosByTrip] {
//        return self.photosSorter.sortBySpecialTrips(photos: self.photosFetcher.allPhotos)
//    }
    
    func instantiateView() -> some View {
        AlbumsListView(viewModel: self)
    }
}
