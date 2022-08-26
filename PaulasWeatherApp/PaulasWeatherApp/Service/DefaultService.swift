//
//  DefaultService.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/23/22.
//

import Foundation

final class DefaultService: NSObject {
    static let defaults = UserDefaults.standard
    
    static func getDefaultStringValue(forKey: String) -> String {
        return defaults.string(forKey: forKey) ?? " "
    }
    
    static func getDefaultIntValue(forKey: String) -> Int {
        return defaults.integer(forKey: forKey)
    }
    
    static func getDefaultDoubleValue(forKey: String) -> Double {
        return defaults.double(forKey: forKey)
    }
    
    static func setDefaultValue(forKey: String, value: Any) {
        defaults.set(value, forKey: forKey)
    }
}
