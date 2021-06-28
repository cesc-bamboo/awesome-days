//
//  UserDefaultsExtension.swift
//  AwesomeDays
//
//  Created by Francesc Navarro on 28/6/21.
//

import Foundation

extension UserDefaults {
    func exists(key: String) -> Bool {
        UserDefaults.standard.object(forKey: key) != nil
    }
}
