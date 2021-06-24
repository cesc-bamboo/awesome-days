//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI
import Photos

enum SortType {
    case SpecialDays, SpecialLocations, SpecialTrips
}

class AlbumsListViewModel: ObservableObject {
    let photosFetcher: PhotosFetcher
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
            }
        }
    }
    
    func allPhotosBySpecialDays() -> [PhotosByDay] {
        return self.photosSorter.sortBySpecialDays(photos: self.photosFetcher.allPhotos)
    }
    
    func allPhotosBySpecialLocations() -> [PhotosByLocation] {
        return self.photosSorter.sortBySpecialLocations(photos: self.photosFetcher.allPhotos)
    }
    
    func allPhotosBySpecialTrips() -> [PhotosByTrip] {
        return self.photosSorter.sortBySpecialTrips(photos: self.photosFetcher.allPhotos)
    }
    
//    func thumbnail(for asset: PHAsset?, completionHandler: @escaping (UIImage?) -> ()) {
//        guard let asset = asset else {
//            completionHandler(nil)
//            return
//        }
//        photosFetcher.fetchImage(asset: asset, completionHandler: completionHandler)
//    }
    
    func thumbnail(for asset: PHAsset?, completionHandler: @escaping (UIImage?) -> ()) {
        guard let asset = asset else {
            completionHandler(nil)
            return
        }
        photosFetcher.fetchImage(asset: asset, completionHandler: completionHandler)
    }
    
    func instantiateView() -> some View {
        AlbumsListView(viewModel: self)
    }
}
