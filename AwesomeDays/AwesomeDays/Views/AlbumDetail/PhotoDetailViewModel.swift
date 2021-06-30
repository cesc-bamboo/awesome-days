//
//  AlbumDetailViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 29/6/21.
//

import Foundation
import SwiftUI
import Photos

class PhotoDetailViewModel: ObservableObject {
    private let photosFetcher: PhotosFetcher?
    @Published var image: UIImage?
    
    init(image: UIImage) {
        self.photosFetcher = nil
        self.image = image
    }
    
    init(asset: PHAsset, photosFetcher: PhotosFetcher = AppContext.photosFetcher) {
        self.photosFetcher = photosFetcher
        photosFetcher.fetchFullSizeImage(asset: asset) { image in
            self.image = image
        }
    }
    
    func instantiateView() -> some View {
        PhotoDetailView(viewModel: self)
    }
}
