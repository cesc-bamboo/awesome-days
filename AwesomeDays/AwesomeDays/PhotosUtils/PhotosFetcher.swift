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
    var imageCache = ImageCache.getImageCache()
    
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
    
    func fetchFullSizeImage(asset: PHAsset, completionHandler: @escaping (UIImage?) -> ()) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        
        let fullImageKey = "\(asset.hash)-full"
        if let cacheImage = fetchImageFromCache(key: fullImageKey) {
            completionHandler(cacheImage)
        } else {
            imageManager.requestImage(for: asset,
                                         targetSize: PHImageManagerMaximumSize,
                                         contentMode: .aspectFit,
                                         options: options,
                                         resultHandler: { (image, info) in
                self.cacheImage(image, key: fullImageKey)
                completionHandler(image)
            })
        }
    }
    
    func fetchThumbnailImage(asset: PHAsset, lowResHandler: ((UIImage?) ->())?, highResHandler: ((UIImage?) ->())?) {
        var lowResRequest: PHImageRequestID? = nil
        
        if let lowResHandler = lowResHandler {
            let lowResImageKey = "\(asset.hash)-thumbnail-low"
            if let cacheImage = fetchImageFromCache(key: lowResImageKey) {
                lowResHandler(cacheImage)
            } else {
            
            
            let lowResOptions = PHImageRequestOptions()
            lowResOptions.deliveryMode = .fastFormat
            lowResOptions.isSynchronous = false
            
            lowResRequest = imageManager.requestImage(for: asset,
                                                         targetSize: CGSize(width: 512.0, height: 512.0),
                                                         contentMode: .aspectFit,
                                                         options: lowResOptions,
                                                         resultHandler: { (image, info) in
                self.cacheImage(image, key: lowResImageKey)
                lowResHandler(image)
            })
            }
        }
        
        if let highResHandler = highResHandler {
            let highResImageKey = "\(asset.hash)-thumbnail-high"
            if let cacheImage = fetchImageFromCache(key: highResImageKey) {
                highResHandler(cacheImage)
            } else {
                
            let highResOptions = PHImageRequestOptions()
            highResOptions.deliveryMode = .highQualityFormat
            highResOptions.isSynchronous = false
            
            imageManager.requestImage(for: asset,
                                         targetSize: CGSize(width: 512.0, height: 512.0),
                                         contentMode: .aspectFit,
                                         options: highResOptions,
                                         resultHandler: { (image, info) in
                
                if let lowResRequest = lowResRequest {
                    // If we already have the high resolution image, we cancel the low resolution request
                    self.imageManager.cancelImageRequest(lowResRequest)
                }
                self.cacheImage(image, key: highResImageKey)
                highResHandler(image)
            })
            }
        }
    }
    
    func fetchImageFromCache(key: String) -> UIImage? {
        let img = imageCache.get(forKey: key)
        if img != nil {
            print("Cache: hit for key \(key)")
        }
        return img
    }
    
    func cacheImage(_ image: UIImage?, key: String) {
        guard let image = image else { return }
        print("Cache: saving key \(key)")
        imageCache.set(forKey: key, image: image)
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
