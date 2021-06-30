//
//  RemoteImage.swift
//  BambooNewsUI
//
//  Created by Francesc Navarro on 15/06/2021.
//  Copyright © 2021 Francesc Navarro. All rights reserved.
//

import Foundation
import SwiftUI
import Photos

struct RemoteImageView: View {
    static var loaders: [PHAsset:ImageLoader] = [:]
    static func loaderFor(asset: PHAsset) -> ImageLoader? { loaders[asset] }
    
    @ObservedObject var imageLoader: ImageLoader
    
    init(with asset: PHAsset, photosFetcher: PhotosFetcher = AppContext.photosFetcher) {
        if let loaderInCache = RemoteImageView.loaderFor(asset: asset) {
            imageLoader = loaderInCache
        } else {
            imageLoader = ImageLoader(asset: asset, photosFetcher: photosFetcher)
            RemoteImageView.loaders[asset] = imageLoader
        }
    }
    
    var body: some View {
        Image(uiImage: imageLoader.image ?? UIImage() )
            .resizable()
    }
}
