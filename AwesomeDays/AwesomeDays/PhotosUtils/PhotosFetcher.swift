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
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized ? true : false)
        }
    }
    
    func fetchAssets(includePhotos: Bool = true, includeSmartAlbums: Bool = false, includeCollection: Bool = false) {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
        if includePhotos {
            allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        }
        
        if includeSmartAlbums {
            smartAlbums = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: .albumRegular,
                options: nil)
        }
        
        if includeCollection {
            userCollections = PHAssetCollection.fetchAssetCollections(
                with: .album,
                subtype: .albumRegular,
                options: nil)
        }
    }
    
    func fetchFullSizeImage(asset: PHAsset, completionHandler: @escaping (UIImage?) -> ()) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        
        let fullImageKey = "\(asset.hash)-full"
        imageFromCacheOrRequest(for: asset,
                                   targetSize: PHImageManagerMaximumSize,
                                   options: options,
                                   cacheKey: fullImageKey,
                                   completionHandler: completionHandler)
    }
    
    func fetchThumbnailImage(asset: PHAsset, lowResHandler: ((UIImage?) ->())?, highResHandler: ((UIImage?) ->())?) {
        let lowResImageKey = "\(asset.hash)-thumbnail-low"
        let highResImageKey = "\(asset.hash)-thumbnail-high"
        
        // 1. Search high resolution thumbnail in cache. If we already have it, return it in highResHandler
        if let highResHandler = highResHandler,
           let highResCacheImage = fetchImageFromCache(key: highResImageKey) {
            print("Cache: hit and shortcut for key \(highResImageKey)")
            highResHandler(highResCacheImage)
            return
        }
        
        // 2. If there is no high resolution thumbnail, we'll have to fetch it. We'll fetch (or take from cache) the low resolution thumbnail to present an image quickly
        if let lowResHandler = lowResHandler {
            let lowResOptions = PHImageRequestOptions()
            lowResOptions.deliveryMode = .fastFormat
            lowResOptions.isSynchronous = false
            imageFromCacheOrRequest(for: asset,
                                       targetSize: CGSize(width: 512.0, height: 512.0),
                                       options: lowResOptions,
                                       cacheKey: lowResImageKey,
                                       completionHandler: lowResHandler)
        }
        
        if let highResHandler = highResHandler {
            let highResOptions = PHImageRequestOptions()
            highResOptions.deliveryMode = .highQualityFormat
            highResOptions.isSynchronous = false
            imageFromCacheOrRequest(for: asset,
                                       targetSize: CGSize(width: 512.0, height: 512.0),
                                       options: highResOptions,
                                       cacheKey: highResImageKey,
                                       completionHandler: highResHandler)
        }
    }
    
    func imageFromCacheOrRequest(for asset: PHAsset,
                                 targetSize: CGSize,
                                 options: PHImageRequestOptions,
                                 cacheKey: String,
                                 completionHandler: @escaping (UIImage?) -> ()) {
        if let cacheImage = fetchImageFromCache(key: cacheKey) {
            completionHandler(cacheImage)
        } else {
            requestImageAndSaveToCache(for: asset,
                                          targetSize: PHImageManagerMaximumSize,
                                          options: options,
                                          cacheKey: cacheKey,
                                          completionHandler: completionHandler)
        }
    }
    
    @discardableResult private func requestImageAndSaveToCache(for asset: PHAsset,
                                                               targetSize: CGSize,
                                                               options: PHImageRequestOptions,
                                                               cacheKey: String,
                                                               completionHandler: @escaping (UIImage?) -> ()) -> PHImageRequestID {
        return imageManager.requestImage(for: asset,
                                            targetSize: targetSize,
                                            contentMode: .aspectFit,
                                            options: options,
                                            resultHandler: { (image, info) in
            self.cacheImage(image, key: cacheKey)
            completionHandler(image)
        })
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
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
            }
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
            }
        }
    }
}
