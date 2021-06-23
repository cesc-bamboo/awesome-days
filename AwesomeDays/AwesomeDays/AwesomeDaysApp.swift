//
//  AwesomeDaysApp.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 22/6/21.
//

import SwiftUI

@main
struct AwesomeDaysApp: App {
    var body: some Scene {
        WindowGroup {
            HomeTabViewModel().instantiateView()
        }
    }
}
