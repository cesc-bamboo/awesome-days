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
                    VStack {
                        Text(specialDay.description)
                        AlbumCellViewModel(assets: specialDay.photos, photosFetcher: viewModel.photosFetcher)
                            .instantiateView()
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
