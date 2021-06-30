//
//  RemoteImage.swift
//  BambooNewsUI
//
//  Created by Francesc Navarro on 15/06/2021.
//  Copyright © 2021 Francesc Navarro. All rights reserved.
//

import Foundation
import SwiftUI
import Photos

struct RemoteImageView: View {
    @StateObject var viewModel: RemoteImageViewModel
    
    var body: some View {
        Image(uiImage: viewModel.image ?? UIImage() )
            .resizable()
    }
}
