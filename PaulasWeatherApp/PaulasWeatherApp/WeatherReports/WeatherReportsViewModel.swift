//
//  WeatherReportsViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/24/22.
//

import Foundation

class WeatherReportsViewModel: NSObject {
    var unitType = DefaultService.getDefaultStringValue(forKey: "Unit of measurement")
    var hourlyWeather: [WeatherDetails] = [] {
        didSet {
            self.setHourlyWeather()
        }
    }
    
    var setHourlyWeather: (() -> ()) = {}
    
    func setHourlyData(hourlyWeather: [WeatherDetails] ) {
        self.hourlyWeather = hourlyWeather
        removeDataAfterCurrentTime()
    }
    
    func removeDataAfterCurrentTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        var hourlyWeatherCopy: [WeatherDetails] = []
        for item in hourlyWeather {
            let comingFromTheServer = TimeInterval(item.dt)
            let calendar2 = Calendar.current
            let date2 = Date(timeIntervalSince1970: comingFromTheServer)
            let hourWeather = calendar2.component(.hour, from: date2)
            if hour - hourWeather < 0, !hourlyWeatherCopy.contains(where: { $0.dt == item.dt }) {
                hourlyWeatherCopy.append(item)
            }
        }
        self.hourlyWeather = hourlyWeatherCopy
    }
    
    func setNewTemperature(row: Int) -> Double {
        unitType = DefaultService.getDefaultStringValue(forKey: "Unit of measurement")
        if row < hourlyWeather.count {
            return ConversionService.convert(temperature: hourlyWeather[row].temp, to: unitType)
        } else {
            return 0.0
        }
    }
}
