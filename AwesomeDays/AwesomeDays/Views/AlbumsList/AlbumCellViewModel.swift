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
    
    init(assets: [PHAsset], photosFetcher: PhotosFetcher) {
        self.assets = assets
        self.photosFetcher = photosFetcher
    }
    
    var coverAsset: PHAsset? { assets.first }
    
    func instantiateView() -> some View {
        AlbumCell(viewModel: self)
    }
}
