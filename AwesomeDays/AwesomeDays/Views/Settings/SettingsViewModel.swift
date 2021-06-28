//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    
    func instantiateView() -> some View {
        SettingsView(viewModel: self, picturesPerDay: 8, picturesPerLocation: 4, daysPerTrip: 3)
    }
}
