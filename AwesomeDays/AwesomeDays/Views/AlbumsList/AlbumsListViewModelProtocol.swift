//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI
import Photos
import Combine

protocol AlbumListViewModelProtocol: ObservableObject {
    associatedtype P: PhotosByProtocol
    func photosToPresent() -> [P]
    
    var photosFetcher: PhotosFetcher { get }
    func fetchPhotosAskingPermission()
}

class AlbumsListViewModelDefault<PhotosByType: PhotosByProtocol>: AlbumListViewModelProtocol {
    let photosFetcher: PhotosFetcher
    let photosSorter: PhotosSorter
    var photosAlreadySorted: [PhotosByType]?
    
    @Published var allPhotos = PHFetchResult<PHAsset>()
    @Published var smartAlbums = PHFetchResult<PHAssetCollection>()
    @Published var userCollections = PHFetchResult<PHAssetCollection>()
    
    private let settingsStorage: SettingsStorage
    @Published var valueUpdated: Bool = true
    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?
    
    init(photosToPresent: [PhotosByType]? = nil,
         photosFetcher: PhotosFetcher = PhotosFetcher(),
         photosSorter: PhotosSorter = PhotosSorter(),
         settingsStorage: SettingsStorage = AppContext.settingsStorage) {
        self.photosAlreadySorted = photosToPresent
        self.photosFetcher = photosFetcher
        self.photosSorter = photosSorter
        self.settingsStorage = settingsStorage
        
        self.cancellable = settingsStorage.publisher.sink { newValue in
            print("## FIRST \(newValue) -> settings storage == \(self.settingsStorage)")
        }
        
        self.cancellable2 = settingsStorage.publisher.sink { newValue in
            print("## CALLED \(newValue)")
            self.photosSorter.setThresholds(isSpecialDayThreshold: self.settingsStorage.load(.PicturesPerDay),
                                            isSpecialLocationThreshold: self.settingsStorage.load(.PicturesPerLocation),
                                            isSpecialTripThreshold: self.settingsStorage.load(.DaysPerTrip))
            self.valueUpdated.toggle()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.settingsStorage.save(.PicturesPerDay, value: 1)
//        }
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
        return photosAlreadySorted ?? []
    }
    //
    //    func allPhotosBySpecialTrips() -> [PhotosByTrip] {
    //        return self.photosSorter.sortBySpecialTrips(photos: self.photosFetcher.allPhotos)
    //    }
    
    func instantiateView() -> some View {
        AlbumsListView(viewModel: self)
    }
}
