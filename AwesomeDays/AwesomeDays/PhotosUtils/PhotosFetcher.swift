//
//  PhotosFetcher.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import Photos
import UIKit

class PhotosFetcher: NSObject {
    let imageManager = PHCachingImageManager()
    var allPhotos = PHFetchResult<PHAsset>()
    var smartAlbums = PHFetchResult<PHAssetCollection>()
    var userCollections = PHFetchResult<PHAssetCollection>()
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        // 1
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
        // 2
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized ? true : false)
        }
    }
    
    func fetchAssets() {// 1
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
        // 2
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        // 3
        smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .albumRegular,
            options: nil)
        // 4
        userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil)
    }
    
    func fetchImage(asset: PHAsset, completionHandler: @escaping (UIImage?) -> ()) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        
        imageManager.requestImage(for: asset,
                                     targetSize: CGSize(width: 160.0, height: 160.0),
                                     contentMode: .aspectFill,
                                     options: options,
                                     resultHandler: { (image, info) in
            completionHandler(image)
        })
    }
}

extension PhotosFetcher: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            // 1
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }
            // 2
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
            }
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
            }
        }
    }
}
