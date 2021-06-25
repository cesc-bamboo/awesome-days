//
//  AlbumsListView.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import SwiftUI
import Photos

struct AlbumsListTripView: View {
    @StateObject var viewModel: AlbumsListTripsViewModel
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                LazyVGrid(columns: [GridItem()], spacing: 8) {
                    ForEach(viewModel.tripsToPresent()) { trip in
                        AlbumCellTripsViewModel(photosByDay: trip.photosByDays,
                                                tripTitle: trip.description,
                                                photosFetcher: viewModel.photosFetcher,
                                                parentViewSize: fullView.size)
                            .instantiateView()
                    }
                }
            }
        }.onAppear {
            viewModel.fetchPhotosAskingPermission()
        }
    }
}

struct AlbumsListTripView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsListTripsViewModel().instantiateView()
    }
}
