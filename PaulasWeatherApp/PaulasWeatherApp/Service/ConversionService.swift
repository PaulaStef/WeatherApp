//
//  ConversionService.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/26/22.
//

import Foundation

final class ConversionService: NSObject {
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
