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
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let defaults = UserDefaults.standard
    private let notificationCenter = NotificationCenter.default
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onLocationChanged), name: .locationChanged, object: nil)
        setTabBar()
        setActivityIndicator()
        getWeatherData()
    }
    
    private func setActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setTabBar() {
        setViewControllers([weatherVC, metricsVC, settingsVC ], animated: false)
        guard let settingsImage = UIImage(named: "settings") else { return }
        let size = CGSize(width: 30, height: 30)
        guard let items = tabBar.items else { return }
        let titles = ["Weather", "Metrics", "Settings"]
        let images = [UIImage(systemName: "clock"), UIImage(systemName:"calendar"), resizeImage(image: settingsImage, targetSize: size)]
        for (index, item) in items.enumerated() {
            item.image = images[index]
            item.title = titles[index]
        }
        tabBar.tintColor = .black
    }
        
    private func getWeatherData() {
        activityIndicator.startAnimating()
        let time = Int(NSDate().timeIntervalSince1970 - 100)
        let latitude = defaults.float(forKey: "Latitude")
        let longitude = defaults.float(forKey: "Longitude")
        WeatherService.getWeatherData(lat: latitude, lon: longitude, time: time) { data, response, error in
            let decoder = JSONDecoder()
            guard let data = data else {
                return
            }
            do {
                let decoded = try decoder.decode(WeatherDataModel.self, from: data)
                DispatchQueue.main.async { [self] in
                    metricsVC.setHourlyData(hourlyWeather: decoded.hourly)
                    metricsVC.refresh()
                    weatherVC.setCurrentWeatherData(decoded)
                    activityIndicator.stopAnimating()
                }
            } catch {
                print("Failed to decode JSON \(error)")
            }
        }
    }
    
    @objc private func onLocationChanged() {
        getWeatherData()
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
    
    static func convert(temperature: Double, to unitType: String) -> Double {
        switch unitType {
        case "Celsius":
            return temperature
        case "Fahrenheit":
            return temperature * 9 / 5 + 32
        default:
            return temperature + 273.15
        }
    }
}
