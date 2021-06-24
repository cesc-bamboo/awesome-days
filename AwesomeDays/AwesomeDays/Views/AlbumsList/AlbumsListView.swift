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
                        VStack {
                            Text(specialDay.description)
                            RemoteImageView(with: asset, photosFetcher: viewModel.photosFetcher)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 250)
                        }
                    } else {
                        Image(systemName: "trash.fill")
                    }
                }
            }
        }.onAppear {
            viewModel.fetchPhotosAskingPermission()
        }
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsListViewModel().instantiateView()
    }
}
