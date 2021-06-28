//
//  AlbumsListViewModel.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var picturesPerDay: Int {
        didSet { settingsStorage.save(.PicturesPerDay, value: picturesPerDay) }
    }
    
    @Published var picturesPerLocation: Int {
        didSet { settingsStorage.save(.PicturesPerLocation, value: picturesPerLocation) }
    }
    
    @Published var daysPerTrip: Int {
        didSet { settingsStorage.save(.DaysPerTrip, value: daysPerTrip) }
    }
    
    private var settingsStorage = SettingsStorage()
    
    init() {
        picturesPerDay = settingsStorage.load(.PicturesPerDay)
        picturesPerLocation = settingsStorage.load(.PicturesPerLocation)
        daysPerTrip = settingsStorage.load(.DaysPerTrip)
    }
    
    func instantiateView() -> some View {
        SettingsView(viewModel: self)
    }
}
