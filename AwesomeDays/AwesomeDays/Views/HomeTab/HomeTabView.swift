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
            ForEach(HomeTabs.allCases, id: \.self) { tab in
                tab.view.tabItem {
                    Label(tab.name, systemImage: tab.iconName)
                }
            }
        }.accentColor(.green)
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabViewModel().instantiateView()
    }
}
