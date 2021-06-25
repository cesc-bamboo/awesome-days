//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI

class HomeTabViewModel: ObservableObject {
    
    func instantiateView() -> some View {
        HomeTabView(viewModel: self)
    }
}

enum HomeTabs: CaseIterable {
    case days, locations, trips, settings
    
    var view: some View {
        switch self {
        case .days:
            return AnyView(AlbumsListDaysViewModel().instantiateView())
        case .locations:
            return AnyView(AlbumsListLocationsViewModel().instantiateView())
        case .trips:
            return AnyView(AlbumsListDaysViewModel().instantiateView())
        case .settings:
            return AnyView(SettingsViewModel().instantiateView())
        }
    }
    
    var name: String {
        switch self {
        case .days:
            return "Days"
        case .locations:
            return "Locations"
        case .trips:
            return "Trips"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .days:
            return "calendar"
        case .locations:
            return "mappin.and.ellipse"
        case .trips:
            return "airplane"
        case .settings:
            return "gearshape"
        }
    }
}
