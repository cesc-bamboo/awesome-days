//
//  AlbumsListView.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import SwiftUI
import Photos

struct AlbumsListView: View {
    @StateObject var viewModel: AlbumsListViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem()], spacing: 8) {
                ForEach(viewModel.allPhotosBySpecialDays(), id: \.date) { specialDay in
                    if let asset: PHAsset = specialDay.photos.first {
                        RemoteImageView(withURL: asset, photosFetcher: viewModel.photosFetcher)
                    } else {
                        Image(systemName: "trash.fill")
                    }
                }
            }
        }.onAppear {
            viewModel.fetchPhotosAskingPermission()
        }
//        Text("All photos count: \(viewModel.allPhotos.count)")
//            .onAppear {
//                viewModel.fetchPhotosAskingPermission()
//            }
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsListViewModel().instantiateView()
    }
}
