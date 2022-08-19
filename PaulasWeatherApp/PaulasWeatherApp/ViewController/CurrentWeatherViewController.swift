//
//  WeatherViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    private let tempLabel = UILabel()
    private let sunriseLabel = UILabel()
    private let sunsetLabel = UILabel()
    private var sunsetString = NSMutableAttributedString()
    private var sunriseString = NSMutableAttributedString()
    private let backgroundImage = UIImageView()
    private let notificationCenter: NotificationCenter
    private let defaults = UserDefaults.standard
    private var weatherData: Double?
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onMeasurementUnitChanged), name: .temperatureChanged, object: nil)
        sunsetString = createSunString(for: "sunset")
        sunriseString = createSunString(for: "sunrise")
        setBackgroundImage()
        setTempLabel()
        setSunriseLabel()
        setSunsetLabel()
        view.backgroundColor = .systemRed
    }
    
    private func setTempLabel() {
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.textAlignment = .center
        tempLabel.font = .systemFont(ofSize: 36)
        tempLabel.text = "..."
        tempLabel.backgroundColor = .clear
        tempLabel.sizeToFit()
        view.addSubview(tempLabel)
        NSLayoutConstraint.activate([
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
        ])
    }
    
    private func setSunsetLabel() {
        sunsetLabel.translatesAutoresizingMaskIntoConstraints = false
        sunsetLabel.textAlignment = .center
        sunsetLabel.font = .systemFont(ofSize: 12)
        sunsetLabel.backgroundColor = .clear
        sunsetLabel.attributedText = sunsetString
        sunsetLabel.sizeToFit()
        view.addSubview(sunsetLabel)
        NSLayoutConstraint.activate([
            sunsetLabel.leadingAnchor.constraint(equalTo: sunriseLabel.trailingAnchor,constant: 10),
            sunsetLabel.trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor),
            sunsetLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor)
        ])
    }
    
    private func setSunriseLabel() {
        sunriseLabel.translatesAutoresizingMaskIntoConstraints = false
        sunriseLabel.textAlignment = .center
        sunriseLabel.font = .systemFont(ofSize: 12)
        sunriseLabel.backgroundColor = .clear
        sunriseLabel.attributedText = sunriseString
        sunriseLabel.sizeToFit()
        view.addSubview(sunriseLabel)
        NSLayoutConstraint.activate([
            sunriseLabel.leadingAnchor.constraint(equalTo: tempLabel.leadingAnchor),
            sunriseLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor)
        ])
    }
    
    private func setBackgroundImage() {
        view.addSubviewAligned(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    //MARK: - Label text methods
    private func createSunString(for name: String) -> NSMutableAttributedString {
        let iconsSize = CGRect(x: 0, y: -5, width: 15, height: 15)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: name)?.withTintColor(sunsetLabel.textColor, renderingMode: .alwaysOriginal)
        imageAttachment.bounds = iconsSize
        let atr = NSMutableAttributedString(attachment: imageAttachment)
        
        return atr
    }
    
    private func createTempString(temperature: Double) -> String {
        let temp = Int(round(temperature))
        guard let unitType = defaults.string(forKey: "Unit of measurement") else { return "Error" }
        let unit = String(unitType.first ?? " ")
        return "\(temp) °\(unit)"
    }
    
    //MARK: - WeatherData methods
    func setCurrentWeatherData(_ data: WeatherDataModel) {
        weatherData = data.current.temp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        guard let unitType = defaults.string(forKey: "Unit of measurement") else { return }
        let temperature = ViewController.convert(temperature: data.current.temp, to: unitType)
        tempLabel.text = createTempString(temperature: temperature)
        guard let sunset = data.current.sunset,
              let sunrise = data.current.sunrise else { return }
        sunsetString = createSunString(for: "sunset")
        sunriseString = createSunString(for: "sunrise")
        sunsetString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(sunset))) ))
        sunsetLabel.attributedText = sunsetString
        sunriseString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(sunrise)))))
        sunriseLabel.attributedText = sunriseString
    }
    
    //MARK: - Measurement unit methods
    @objc private func onMeasurementUnitChanged() {
        guard let weatherData = weatherData else { return }
        guard let unitType = defaults.string(forKey: "Unit of measurement") else { return }
        let newTemperature = ViewController.convert(temperature: weatherData, to: unitType)
        tempLabel.text = createTempString(temperature: newTemperature)
    }
}
