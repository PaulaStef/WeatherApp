//
//  DefaultService.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/23/22.
//

import Foundation

class DefaultService: NSObject {
    static let defaults = UserDefaults.standard
    
    static func getDefaultStringValue(forKey: String) -> String {
        return defaults.string(forKey: forKey) ?? " "
    }
    
    static func getDefaultIntValue(forKey: String) -> Int {
        return defaults.integer(forKey: forKey)
    }
    
    static func setDefaultValue(forKey: String, value: Any) {
        defaults.set(value, forKey: forKey)
    }
    
    static func convert(temperature: Double, to unitType: String) -> Double {
        switch unitType {
        case "Celsius":
            return temperature
        case "Fahrenheit":
            return temperature * 9 / 5 + 32
        default:
            return temperature + 273.15
        }
    }
}
