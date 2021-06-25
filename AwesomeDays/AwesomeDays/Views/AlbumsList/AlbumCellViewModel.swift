//
//  AlbumCellViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 25/6/21.
//

import Foundation
import SwiftUI
import Photos

class AlbumCellViewModel: ObservableObject {
    let assets: [PHAsset]
    let photosFetcher: PhotosFetcher
    let parentViewSize: CGSize
    
    init(assets: [PHAsset], photosFetcher: PhotosFetcher, parentViewSize: CGSize) {
        self.assets = assets
        self.photosFetcher = photosFetcher
        self.parentViewSize = parentViewSize
    }
    
    var coverAsset: PHAsset? { assets.first }
    
    func instantiateView() -> some View {
        AlbumCell(viewModel: self)
    }
}
