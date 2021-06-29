//
//  AlbumsListView.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import SwiftUI
import Photos

struct AlbumsListView<ViewModel>: View where ViewModel: AlbumListViewModelProtocol {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                LazyVGrid(columns: [GridItem()], spacing: 8) {
                    ForEach(viewModel.photosToPresent()) { photosAlbum in
                        VStack {
                            Text(photosAlbum.description)
                            AlbumCellViewModel(assets: photosAlbum.photos,
                                               photosFetcher: viewModel.photosFetcher,
                                               parentViewSize: fullView.size)
                                .instantiateView()
                        }
                    }
                }
            }
        }
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsListDaysViewModel().instantiateView()
    }
}
