//
//  PhotosByProtocol.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 25/6/21.
//

import Foundation
import Photos

protocol PhotosByProtocol: CustomStringConvertible, Identifiable {
    var description: String { get }
    var photos: [PHAsset] { get set }
    var uuid: UUID { get }
    
}

extension PhotosByProtocol {
    var id: UUID { uuid }
}
