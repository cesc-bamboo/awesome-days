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
                    Label("Days", systemImage: "calendar")
                }
            
            AlbumsListViewModel().instantiateView()
                .tabItem {
                    Label("Locations", systemImage: "mappin.and.ellipse")
                }
            
            AlbumsListViewModel().instantiateView()
                .tabItem {
                    Label("Trips", systemImage: "airplane")
                }
            
            SettingsViewModel().instantiateView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }.accentColor(.green)
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabViewModel().instantiateView()
    }
}
