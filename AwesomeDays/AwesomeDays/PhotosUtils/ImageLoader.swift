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
    var urlString: PHAsset
    var photosFetcher: PhotosFetcher
    var imageCache = ImageCache.getImageCache()

    init(urlString: PHAsset, photosFetcher: PhotosFetcher) {
        self.urlString = urlString
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
        guard let cacheImage = imageCache.get(forKey: "\(urlString.hash)") else {
            return false
        }

        image = cacheImage
        return true
    }

    func loadImageFromUrl() {
//        let url = URL(string: urlString)!
//        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
//        task.resume()
        
        photosFetcher.fetchImage(asset: urlString, completionHandler: getImageFetched)
    }
    
    func getImageFetched(image: UIImage?) {
        guard let image = image else {
            print("No image found")
            return
        }
        
        DispatchQueue.main.async {
            self.imageCache.set(forKey: "\(self.urlString.hash)", image: image)
            self.image = image
        }
    }
}
