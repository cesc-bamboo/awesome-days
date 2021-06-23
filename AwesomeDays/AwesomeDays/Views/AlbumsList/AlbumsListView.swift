//
//  AlbumsListView.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import SwiftUI

struct AlbumsListView: View {
    @StateObject var viewModel: AlbumsListViewModel
    
    var body: some View {
        Text("All photos count: \(viewModel.allPhotos.count)")
            .onAppear {
                viewModel.fetchPhotosAskingPermission()
            }
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsListViewModel().instantiateView()
    }
}
