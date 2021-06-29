//
//  ImageDownloader.swift
//  BambooNewsUI
//
//  Created by Francesc Navarro on 15/06/2021.
//  Copyright © 2021 Francesc Navarro. All rights reserved.
//

import Foundation
import Combine
import UIKit
import Photos

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let asset: PHAsset
    private let photosFetcher: PhotosFetcher
    var imageCache = ImageCache.getImageCache()

    init(asset: PHAsset, photosFetcher: PhotosFetcher = AppContext.photosFetcher) {
        self.asset = asset
        self.photosFetcher = photosFetcher
        loadImage()
    }

    func loadImage() {
        if loadImageFromCache() {
            print("Cache hit")
            return
        }

        print("Cache miss, loading from url")
        loadImageFromUrl()
    }

    func loadImageFromCache() -> Bool {
        guard let cacheImage = imageCache.get(forKey: "\(asset.hash)") else {
            return false
        }

        image = cacheImage
        return true
    }

    func loadImageFromUrl() {
        photosFetcher.fetchImage(asset: asset, completionHandler: getImageFetched)
    }
    
    func getImageFetched(image: UIImage?) {
        guard let image = image else {
            print("No image found")
            return
        }
        
        DispatchQueue.main.async {
            self.imageCache.set(forKey: "\(self.asset.hash)", image: image)
            self.image = image
        }
    }
}
