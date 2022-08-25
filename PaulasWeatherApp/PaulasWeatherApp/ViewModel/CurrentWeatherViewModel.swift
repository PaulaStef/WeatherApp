//
//  CurrentWeatherViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/24/22.
//

import Foundation

class CurrentWeatherViewModel: NSObject {
    private var weatherData: Double?
    var unitType = DefaultService.getDefaultStringValue(forKey: "Unit of measurement")
    var temperature: Double? {
        didSet {
            setTemperature()
        }
    }
    var sunset: Int? {
        didSet {
            setSunset()
        }
    }
    var sunrise: Int? {
        didSet {
            setSunrise()
        }
    }
    
    var setTemperature: (() -> ()) = {}
    var setSunset: (() -> ()) = {}
    var setSunrise: (() -> ()) = {}
    
    func setCurrentWeatherData(_ data: WeatherDataModel) {
        weatherData = data.current.temp
        setNewTemperature()
        sunset = data.current.sunset ?? 0
        sunrise = data.current.sunrise ?? 0
    }
    
    func setNewTemperature() {
        unitType = DefaultService.getDefaultStringValue(forKey: "Unit of measurement")
        temperature = DefaultService.convert(temperature: weatherData ?? 0.0, to: unitType)
    }
}
