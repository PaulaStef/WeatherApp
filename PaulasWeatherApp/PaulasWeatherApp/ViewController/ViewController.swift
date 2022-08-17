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
        
        guard let settingsImage = UIImage(named: "settings") else { return }
        let size = CGSize(width: 35, height: 35)
        guard let items = tabBar.items else { return }
        let images = [UIImage(systemName: "clock"), UIImage(systemName:"calendar"), resizeImage(image: settingsImage, targetSize: size)]
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
                    metricsVC.setHourlyData(hourlyWeather: decoded.hourly)
                    weatherVC.setCurrentWeatherData(decoded)
                }
            } catch {
                print("Failed to decode JSON \(error)")
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio,  height: size.height * ratio)
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
     
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else
        {
            return image
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
