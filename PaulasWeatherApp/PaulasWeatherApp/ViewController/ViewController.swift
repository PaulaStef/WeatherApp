//
//  ViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class ViewController: UITabBarController {
    var countryCityName: String?
    var currentWeather: WeatherDetails?
    var hourlyWeatherList = [WeatherDetails]()
    var dailyWeatherList = [Daily]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let WeatherVC = CurrentWeatherViewController()
        let MetricsVC = WeatherReportsViewController()
        let SettingsVC = SettingsViewController()
        
        self.setViewControllers([WeatherVC ,MetricsVC ,SettingsVC ], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["clock", "calendar", "gear.circle"]
        
        for x in 0...2 {
            items[x].image = UIImage(systemName: images[x])
        }
        
        self.tabBar.tintColor = .black
        let time = Int(NSDate().timeIntervalSince1970)
        gettingWeatherData(lat: 33.44, lon: -94.04, time: time)
    }
    
    func gettingWeatherData(lat: Float, lon: Float, time: Int) {
        dailyWeatherList.removeAll()
        hourlyWeatherList.removeAll()
        WeatherService.getWeatherData(lat: lat, lon: lon, time: time) { data, response, error in
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(WeatherDataModel.self, from: data!)
                self.countryCityName = decoded.timezone
                self.currentWeather = decoded.current
                //self.hourlyWeatherList = decoded.hourly
                //self.dailyWeatherList = decoded.daily
                DispatchQueue.main.async { [self] in
                    print(decoded.timezone)
                    print(decoded)
                }
            } catch {
                print("Failed to decode JSON \(error)")
            }
        }
    }
}
