//
//  HourlyWeatherViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/24/22.
//

import Foundation

class HourlyWeatherViewModel: NSObject {
    private let weatherDetails: WeatherDetails
    private let defaults = UserDefaults.standard
    var unitType = DefaultService.getDefaultStringValue(forKey: "Unit of measurement")
    var temperature: Int?
    
    init(for hourlyWeather: WeatherDetails) {
        self.weatherDetails = hourlyWeather
        temperature = Int(round(ConversionService.convert(temperature: weatherDetails.temp , to: unitType)))
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getValue(for detail: DetailsHourly ) -> String {
        switch detail {
        case .feels_like:
            return "\(temperature ?? 0) °\(unitType.first ?? "C")"
        case .pressure:
            return "\(weatherDetails.pressure)"
        case .humidity:
            return "\(weatherDetails.humidity)"
        case .uvi:
            return "\(weatherDetails.uvi)"
        case .clouds:
            return "\(weatherDetails.clouds)"
        case .visibility:
            return "\(weatherDetails.visibility)"
        case .windSpeed:
            return "\(weatherDetails.windSpeed)"
        }
    }
    
    func setNewTemperature() {
        unitType = DefaultService.getDefaultStringValue(forKey: "Unit of measurement")
        temperature = Int(round(ConversionService.convert(temperature: weatherDetails.temp , to: unitType)))
    }
}
