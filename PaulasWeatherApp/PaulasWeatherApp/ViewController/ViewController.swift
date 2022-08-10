//
//  ViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class ViewController: UITabBarController {
        
    private let weatherVC = CurrentWeatherViewController()
    private let metricsVC = WeatherReportsViewController()
    private let settingsVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        let time = Int(NSDate().timeIntervalSince1970)
        getWeatherData(lat: 33.44, lon: -94.04, time: time)
    }
    
    private func setTabBar() {
        setViewControllers([weatherVC, metricsVC, settingsVC ], animated: false)
        
        guard let items = tabBar.items else { return }
        let images = [UIImage(systemName: "clock"), UIImage(systemName:"calendar"), UIImage(named: "settings")]
        
        for (index, item) in items.enumerated() {
            item.image = images[index]
        }
        tabBar.tintColor = .black
        
        self.tabBar.tintColor = .black
    }
        
    private func getWeatherData(lat: Float, lon: Float, time: Int) {
        WeatherService.getWeatherData(lat: lat, lon: lon, time: time) { data, response, error in
            let decoder = JSONDecoder()
            guard let data = data else {
                return
            }
            do {
                let decoded = try decoder.decode(WeatherDataModel.self, from: data)
                DispatchQueue.main.async { [self] in
                    weatherVC.activityIndicator.stopAnimating()
                    weatherVC.setCurrentWeatherData(decoded)
                }
            } catch {
                print("Failed to decode JSON \(error)")
            }
        }
    }
}
