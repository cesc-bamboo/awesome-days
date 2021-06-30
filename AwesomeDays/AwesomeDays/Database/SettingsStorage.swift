//
//  SettingsStorage.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 28/6/21.
//

import Foundation
import Combine

enum SettingsKey: String {
    case PicturesPerDay, PicturesPerLocation, DaysPerTrip
    
    var defaultValue: Int {
        switch self {
        case .PicturesPerDay:
            return 5
        case .PicturesPerLocation:
            return 8
        case .DaysPerTrip:
            return 2
        }
    }
}

class SettingsStorage {
    private let userDefaults = UserDefaults.standard
    
    let publisher = PassthroughSubject<Bool, Never>()
    
    func save(_ key: SettingsKey, value: Int) {
        userDefaults.set(value, forKey: key.rawValue)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.publisher.send(true)
//        }
        self.publisher.send(true)
    }
    
    func load(_ key: SettingsKey) -> Int {
        if userDefaults.exists(key: key.rawValue) {
            return UserDefaults.standard.integer(forKey: key.rawValue)
        } else {
            return key.defaultValue
        }
    }
}
