//
//  WeatherViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let sunriseLabel = UILabel()
    private let sunsetLabel = UILabel()
    private var sunsetString = NSMutableAttributedString()
    private var sunriseString = NSMutableAttributedString()
    private let backgroundImage = UIImageView()
    private let notificationCenter: NotificationCenter
    private var currentWeatherViewModel: CurrentWeatherViewModel?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    init(notificationCenter: NotificationCenter = .default, currentWeatherViewModel: CurrentWeatherViewModel) {
        self.notificationCenter = notificationCenter
        self.currentWeatherViewModel = currentWeatherViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onMeasurementUnitChanged), name: .unitTypeChanged, object: nil)
        bindViewModel()
        sunsetString = createSunString(for: "sunset")
        sunriseString = createSunString(for: "sunrise")
        setBackgroundImage()
        setTempLabel()
        setCityLabel()
        setSunriseLabel()
        setSunsetLabel()
        view.backgroundColor = .systemRed
    }
    
    private func bindViewModel() {
        guard let currentWeatherViewModel = currentWeatherViewModel else {
            return
        }
        currentWeatherViewModel.setTemperature = {
            self.uploadTempLabelData()
        }
        currentWeatherViewModel.setSunset = {
            self.uploadSunsetLabelData()
        }
        currentWeatherViewModel.setSunrise = {
            self.uploadSunriseLabelData()
        }
        currentWeatherViewModel.setCity = {
            self.uploadCityLabelData()
        }
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
    
    private func setCityLabel() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textAlignment = .center
        cityLabel.font = .systemFont(ofSize: 50)
        cityLabel.text = ""
        cityLabel.backgroundColor = .clear
        cityLabel.sizeToFit()
        view.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor,constant: -50),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
            sunsetLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 10)
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
            sunriseLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 10)
        ])
    }
    
    private func setBackgroundImage() {
        view.addSubviewAligned(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: - Label text methods
    private func createSunString(for name: String) -> NSMutableAttributedString {
        let iconsSize = CGRect(x: 0, y: -5, width: 15, height: 15)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: name)?.withTintColor(sunsetLabel.textColor, renderingMode: .alwaysOriginal)
        imageAttachment.bounds = iconsSize
        let atr = NSMutableAttributedString(attachment: imageAttachment)
        
        return atr
    }
    
    // MARK: - Label Data methods
    private func uploadTempLabelData() {
        let temp = Int(round(currentWeatherViewModel?.temperature ?? 0.0))
        let unit = String(currentWeatherViewModel?.unitType.first ?? " ")
        tempLabel.text =  "\(temp) °\(unit)"
    }
    
    private func uploadCityLabelData() {
        cityLabel.text = currentWeatherViewModel?.city
    }
    
    private func uploadSunsetLabelData() {
        sunsetString = createSunString(for: "sunset")
        sunsetString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(currentWeatherViewModel?.sunset ?? 0))) ))
        sunsetLabel.attributedText = sunsetString
    }
    
    private func uploadSunriseLabelData() {
        sunriseString = createSunString(for: "sunrise")
        sunriseString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(currentWeatherViewModel?.sunrise ?? 0)))))
        sunriseLabel.attributedText = sunriseString
    }
    
    // MARK: - Measurement unit methods
    @objc private func onMeasurementUnitChanged() {
        currentWeatherViewModel?.setNewTemperature()
        uploadTempLabelData()
    }
}
