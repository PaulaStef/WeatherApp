//
//  HourlyWeatherDetailsViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/1/22.
//

import Foundation
import UIKit

enum DetailsHourly: String, CaseIterable{
    case feels_like = "Feels like"
    case pressure = "Pressure"
    case humidity = "Humidity"
    case uvi = "UVI"
    case clouds = "Clouds"
    case visibility = "Visibility"
    case windSpeed = "Wind Speed"
    
    static let allItems: [DetailsHourly] = [.feels_like, .pressure, .humidity, .uvi, .clouds, .visibility, .windSpeed]
}

class HourlyWeatherDetailsViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HourlyWeatherDetailsCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    private let temperatureLabel = UILabel()
    private let backgroundImage = UIImageView()
    private let weatherDetails : WeatherDetails
    
    init(for hourlyWeather: WeatherDetails) {
        self.weatherDetails = hourlyWeather
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundImage()
        setTemperatureLabel()
        setCollectionView()
    }
    
    private func setTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.textAlignment = .center
        view.addSubview(temperatureLabel)
        temperatureLabel.backgroundColor = .clear
        temperatureLabel.text = "\(weatherDetails.temp) °C"
        temperatureLabel.font = .systemFont(ofSize: 42)
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 150) ])
    }
    
    private func setBackgroundImage() {
        view.addSubview(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        NSLayoutConstraint.activate([
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor) ])
    }
    
    private func setCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height/2) ])
    }
    
    func getValue(for detail: DetailsHourly ) -> Any {
        switch detail {
        case .feels_like:
            return weatherDetails.feelsLike
        case .pressure:
            return weatherDetails.pressure
        case .humidity:
            return weatherDetails.humidity
        case .uvi:
            return weatherDetails.uvi
        case .clouds:
            return weatherDetails.clouds
        case .visibility:
            return weatherDetails.visibility
        case .windSpeed:
            return weatherDetails.windSpeed
        }
    }
}

extension HourlyWeatherDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HourlyWeatherDetailsCell
        else {
            return  UICollectionViewCell()
        }
        if indexPath.row < DetailsHourly.allItems.count{
            let detail = DetailsHourly.allItems[indexPath.row]
            cell.titleLabel.text = "\(detail.rawValue)"
            cell.descriptionLabel.text = "\(getValue(for: detail)) "
        }
        
        cell.backgroundColor = .separator
        cell.layer.cornerRadius = 7.0
        cell.selectedBackgroundView = collectionView.backgroundView
        return cell
    }
}

extension HourlyWeatherDetailsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DetailsHourly.allCases.count
    }
}
