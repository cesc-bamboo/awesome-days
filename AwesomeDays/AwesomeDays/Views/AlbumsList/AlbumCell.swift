//
//  AlbumCell.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 25/6/21.
//

import SwiftUI
import Photos

struct AlbumCell: View {
    @StateObject var viewModel: AlbumCellViewModel
    private let coverHeight: CGFloat = 250
    private let gridHeight: CGFloat = 350
    
    @State private var isTapped: Bool = false
    
    var body: some View {
        if (isTapped) {
            photosGrid(with: viewModel.assets)
        } else if let coverAsset = viewModel.coverAsset {
            coverButton(with: coverAsset)
        } else {
            Text("Can't find images!")
        }
        
        
        
//        Button(action: onButtonTap, label: {
//            RemoteImageView(with: asset, photosFetcher: photosFetcher)
//                .aspectRatio(contentMode: .fit)
//                .frame(height: isTapped ? 500 : 250)
//        }).animation(.spring())
    }
    
    func coverButton(with asset: PHAsset) -> some View {
        Button(action: onButtonTap, label: {
            RemoteImageView(with: asset, photosFetcher: viewModel.photosFetcher)
                .aspectRatio(contentMode: .fit)
                .frame(height: coverHeight)
        })
    }
    
    func photosGrid(with assets: [PHAsset]) -> some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem()], spacing: 8) {
                ForEach(assets, id: \.hash) { asset in
                    RemoteImageView(with: asset, photosFetcher: viewModel.photosFetcher)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: gridHeight)
                }
            }
        }
    }
    
    func onButtonTap() {
        isTapped.toggle()
    }
}
