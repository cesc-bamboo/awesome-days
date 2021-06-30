//
//  AlbumCell.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 25/6/21.
//

import SwiftUI
import Photos
import Introspect

struct AlbumTripCell: View {
    @StateObject var viewModel: AlbumTripCellViewModel
    private let coverHeight: CGFloat = 250
    
    @State private var pushPresented: Bool = false
    
    var body: some View {
        VStack {
            Text(viewModel.tripTitle)
            if let coverAsset = viewModel.coverAsset {
                coverButton(with: coverAsset)
            }
            NavigationLink(destination:
                            AlbumsListDaysViewModel(photosToPresent: viewModel.photosByDay).instantiateView(),
                           isActive: self.$pushPresented) {
                EmptyView()
            }.hidden()
        }
    }
    
    func coverButton(with asset: PHAsset) -> some View {
        Button(action: onButtonTap, label: {
            RemoteImageViewModel(with: asset).instantiateView()
                .aspectRatio(contentMode: .fit)
                .frame(height: coverHeight)
        })
    }
    
    func onButtonTap() {
        pushPresented.toggle()
    }
}
