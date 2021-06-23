//
//  AlbumsListView.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject var viewModel: HomeTabViewModel
    
    var body: some View {
        TabView {
            AlbumsListViewModel().instantiateView()
                .tabItem {
                    Label("Albums", systemImage: "photo.on.rectangle.angled")
                }
            
            SettingsViewModel().instantiateView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabViewModel().instantiateView()
    }
}
