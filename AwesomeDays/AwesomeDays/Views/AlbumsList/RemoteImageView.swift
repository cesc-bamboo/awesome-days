//
//  RemoteImage.swift
//  BambooNewsUI
//
//  Created by Francesc Navarro on 15/06/2021.
//  Copyright © 2021 Francesc Navarro. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Photos

struct RemoteImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(with asset: PHAsset, photosFetcher: PhotosFetcher) {
        imageLoader = ImageLoader(asset: asset, photosFetcher: photosFetcher)
    }
    
    var body: some View {
        Image(uiImage: imageLoader.image ?? UIImage() )
            .resizable()
    }
}
