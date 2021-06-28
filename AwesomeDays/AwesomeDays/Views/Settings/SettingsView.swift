//
//  AlbumsListView.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 23/6/21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @State var picturesPerDay: Int
    @State var picturesPerLocation: Int
    @State var daysPerTrip: Int
    
    var body: some View {
        VStack {
            valueStepper(description: "Number of pictures to be considered a special day",
                         value: $picturesPerDay)
            
            valueStepper(description: "Number of pictures in the same location to be considered a special location",
                         value: $picturesPerLocation)
            
            valueStepper(description: "Number of days to be considered a special trip",
                         value: $daysPerTrip)
        }
    }
    
    func valueStepper(description: String, value: Binding<Int>) -> some View {
        VStack {
            Text(description)
            Stepper(value: value,
                    in: 1...999,
                    step: 1) {
                Text("\(value.wrappedValue)")
                    .font(.title)
            }.frame(width: 160)
        }.padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewModel().instantiateView()
    }
}
