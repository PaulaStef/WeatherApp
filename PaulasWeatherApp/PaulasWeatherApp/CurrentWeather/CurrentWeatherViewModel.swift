//
//  CurrentWeatherViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/24/22.
//

import Foundation
import CoreLocation

class CurrentWeatherViewModel: NSObject {
    private var weatherData: Double?
    private var timezone: String?
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
    var city: String? {
        didSet {
            setCity()
        }
    }
    
    var setTemperature: (() -> ()) = {}
    var setSunset: (() -> ()) = {}
    var setSunrise: (() -> ()) = {}
    var setCity: (() -> ()) = {}
    
    func setCurrentWeatherData(_ data: WeatherDataModel) {
        weatherData = data.current.temp
        setNewTemperature()
        sunset = data.current.sunset ?? 0
        sunrise = data.current.sunrise ?? 0
        let location = DefaultService.getDefaultStringValue(forKey: "Location")
        if location.elementsEqual("MyLocation") {
            getCityFromMyLocation()
        } else {
            timezone = data.timezone
            splitTimezone()
        }
    }
    
    private func splitTimezone() {
        if timezone?.contains(where: {$0 == "/" }) != nil {
            let timezoneArr = timezone?.components(separatedBy: "/")
            city = timezoneArr?[1]
        }
    }
    
    func getCityFromMyLocation() {
        let geoCoder = CLGeocoder()
        let latitude = DefaultService.getDefaultDoubleValue(forKey: "Latitude")
        let longitude = DefaultService.getDefaultDoubleValue(forKey: "Longitude")
        let location = CLLocation(latitude: latitude, longitude:  longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                if let city = placemark.locality {
                    self.city = city
                }
            }
        })
    }
    
    func setNewTemperature() {
        unitType = DefaultService.getDefaultStringValue(forKey: "Unit of measurement")
        temperature = ConversionService.convert(temperature: weatherData ?? 0.0, to: unitType)
    }
}
