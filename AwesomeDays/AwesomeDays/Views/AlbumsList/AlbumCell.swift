//
//  AlbumCell.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 25/6/21.
//

import SwiftUI
import Photos
import Introspect

struct AlbumCell: View {
    @StateObject var viewModel: AlbumCellViewModel
    private let coverHeight: CGFloat = 250
    
    @State private var isAlbumExpanded: Bool = false
    
    var body: some View {
        if (isAlbumExpanded) {
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
        let cellWidth: CGFloat = viewModel.parentViewSize.width * 0.9
        let cellHeight: CGFloat = min(cellWidth * 0.75, viewModel.parentViewSize.height)
        
        return ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible(minimum: cellWidth*0.5, maximum: cellWidth))], spacing: 8) {
                ForEach(assets, id: \.hash) { asset in
                    RemoteImageView(with: asset, photosFetcher: viewModel.photosFetcher)
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(height: cellHeight)
        }.introspectScrollView { $0.alwaysBounceVertical = false }
        
    }
    
    func onButtonTap() {
        isAlbumExpanded.toggle()
    }
}
