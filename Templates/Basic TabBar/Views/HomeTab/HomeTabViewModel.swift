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
