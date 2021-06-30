//
//  RemoteImageViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 30/6/21.
//

import Foundation
import SwiftUI
import Photos
import Combine

class RemoteImageViewModel: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    init(with asset: PHAsset, photosFetcher: PhotosFetcher = AppContext.photosFetcher) {
        photosFetcher.fetchThumbnailImage(asset: asset,
                                          lowResHandler: { image in self.image = image },
                                          highResHandler: { image in self.image = image })
    }
    
    func instantiateView() -> some View {
        RemoteImageView(viewModel: self)
    }
}
