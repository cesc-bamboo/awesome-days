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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AlbumsListView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsListViewModel().instantiateView()
    }
}
