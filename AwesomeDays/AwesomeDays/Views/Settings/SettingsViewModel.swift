//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var picturesPerDay: Int = 8
    @Published var picturesPerLocation: Int = 4
    @Published var daysPerTrip: Int = 3
    
    func instantiateView() -> some View {
        SettingsView(viewModel: self)
    }
}
