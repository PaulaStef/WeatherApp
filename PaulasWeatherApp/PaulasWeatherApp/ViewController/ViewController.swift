//
//  ViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class ViewController: UITabBarController {
    private let weatherViewModel = WeatherViewModel()
    private let currentWeatherVM = CurrentWeatherViewModel()
    private let weatherReportsVM = WeatherReportsViewModel()
    private let settingsVM = SettingsViewModel(firstDayOfTheWeekViewModel: FirstDayOfTheWeekViewModel(), unitOfMeasurementViewModel: UnitOfMeasurementViewModel(), locationViewModel: LocationViewModel())
    private let unitOfMeasurementVM = UnitOfMeasurementViewModel()
    private let locationVM = LocationViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let notificationCenter = NotificationCenter.default
    
    deinit {
        notificationCenter.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onLocationChanged), name: .locationChanged, object: nil)
        setTabBar()
        setActivityIndicator()
        bindView()
        callToViewModelForUpdate()
    }
    
    private func bindView() {
        weatherViewModel.weatherDataUpdated = {
            DispatchQueue.main.async {
                self.updateViewControllersData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setTabBar() {
        let weatherVC = CurrentWeatherViewController(currentWeatherViewModel: currentWeatherVM)
        let metricsVC = WeatherReportsViewController(weatherReportsViewModel: weatherReportsVM)
        let settingsVC = SettingsViewController(settingsViewModel: settingsVM)
        setViewControllers([weatherVC, metricsVC, settingsVC], animated: false)
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
    
    //MARK: - Data methods
    private func callToViewModelForUpdate() {
        activityIndicator.startAnimating()
        weatherViewModel.getWeatherData()
    }
    
    private func updateViewControllersData() {
        guard let data = weatherViewModel.weatherData else { return }
        DispatchQueue.main.async {
            self.currentWeatherVM.setCurrentWeatherData(data)
            self.weatherReportsVM.setHourlyData(hourlyWeather: data.hourly)
        }
    }
    
    //MARK: - Location methods
    @objc private func onLocationChanged() {
        callToViewModelForUpdate()
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
