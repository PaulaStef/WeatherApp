//
//  ViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class ViewController: UITabBarController {
    
    let WeatherVC = CurrentWeatherViewController()
    let MetricsVC = WeatherReportsViewController()
    let SettingsVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        WeatherService.getWeatherData(lat: lat, lon: lon, time: time) { data, response, error in
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(WeatherDataModel.self, from: data!)
                DispatchQueue.main.async { [self] in
                    print(decoded.timezone)
                    WeatherVC.setCurrentWeatherUI(decoded)
                }
            } catch {
                print("Failed to decode JSON \(error)")
            }
        }
    }

}

