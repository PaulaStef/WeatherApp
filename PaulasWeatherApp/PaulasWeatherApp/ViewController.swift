//
//  ViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let WeatherVC = WeatherViewController()
        let MetricsVC = MetricsViewController()
        let SettingsVC = SettingsViewController()
        
        self.setViewControllers([WeatherVC ,MetricsVC ,SettingsVC ], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["clock", "calendar", "gear.circle"]
        
        for x in 0...2 {
            items[x].image = UIImage(systemName: images[x])
        }
        
        self.tabBar.tintColor = .black
    }
    

}

