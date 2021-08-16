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
    @Published var photosAlreadySorted: [PhotosByType]?
    
    private let settingsStorage: SettingsStorage
    private var cancellable: AnyCancellable?
    
    init(photosToPresent: [PhotosByType]? = nil,
         photosFetcher: PhotosFetcher = AppContext.photosFetcher,
         photosSorter: PhotosSorter = PhotosSorter(),
         settingsStorage: SettingsStorage = AppContext.settingsStorage) {
        self.photosAlreadySorted = photosToPresent
        self.photosFetcher = photosFetcher
        self.photosSorter = photosSorter
        self.settingsStorage = settingsStorage
        
        observeChangesInSettings()
        updateSorterThresholds()
        fetchPhotosAskingPermission()
    }
    
    private func observeChangesInSettings() {
        self.cancellable = settingsStorage.publisher.sink { newValue in
            self.updateSorterThresholds()
            self.photosAlreadySorted = nil
        }
    }
    
    private func updateSorterThresholds() {
        photosSorter.setThresholds(isSpecialDayThreshold: self.settingsStorage.load(.PicturesPerDay),
                                        isSpecialLocationThreshold: self.settingsStorage.load(.PicturesPerLocation),
                                        isSpecialTripThreshold: self.settingsStorage.load(.DaysPerTrip))
    }
    
    func fetchPhotosAskingPermission() {
        photosFetcher.getPermissionIfNecessary { granted in
            guard granted else { return }
            self.photosFetcher.fetchAssets()
        }
    }
    
    func photosToPresent() -> [PhotosByType] {
        return photosAlreadySorted ?? []
    }
    
    func instantiateView() -> some View {
        AlbumsListView(viewModel: self)
    }
}
