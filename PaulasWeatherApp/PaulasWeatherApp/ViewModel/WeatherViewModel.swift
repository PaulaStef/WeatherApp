//
//  WeatherViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/19/22.
//

import Foundation

class WeatherViewModel: NSObject {
    private var weatherService: WeatherService?
    private let defaults = UserDefaults.standard
    private(set) var weatherData: WeatherDataModel? {
        didSet {
            weatherDataUpdated()
        }
    }
    var weatherDataUpdated : (() -> ()) = {}
    
    override init() {
        super.init()
        weatherService = WeatherService()
    }
    //MARK: - Get data methods
    func getWeatherData() {
        let time = Int(NSDate().timeIntervalSince1970 - 100)
        let latitude = defaults.float(forKey: "Latitude")
        let longitude = defaults.float(forKey: "Longitude")
        guard let weatherService = weatherService else {
            return
        }
        weatherService.getWeatherData(lat: latitude, lon: longitude, time: time) { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(WeatherDataModel.self, from: data)
                self?.weatherData = decoded
            } catch {
                print("Failed to decode JSON \(error)")
            }
        }
    }
}
