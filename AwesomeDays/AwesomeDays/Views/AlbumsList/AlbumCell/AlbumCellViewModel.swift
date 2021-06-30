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
    private let photosFetcher: PhotosFetcher
    @Published var assets: [PHAsset]
    @Published var parentViewSize: CGSize
    
    init(assets: [PHAsset], photosFetcher: PhotosFetcher = AppContext.photosFetcher, parentViewSize: CGSize) {
        self.assets = assets
        self.photosFetcher = photosFetcher
        self.parentViewSize = parentViewSize
    }
    
    var coverAsset: PHAsset? { assets.first }
    
    func instantiateView() -> some View {
        AlbumCell(viewModel: self)
    }
}
