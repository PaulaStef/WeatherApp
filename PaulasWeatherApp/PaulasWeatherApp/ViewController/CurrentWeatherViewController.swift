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
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActivityIndicator()
        
        sunsetString = createString(for: "sunset")
        sunriseString = createString(for: "sunrise")
        
        setTempLabel()
        setSunriseLabel()
        setSunsetLabel()
        view.backgroundColor = .systemRed
    }
    
    private func setActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setTempLabel() {
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.textAlignment = .center
        tempLabel.font = .systemFont(ofSize: 36)
        tempLabel.textColor = .black
        tempLabel.text = "... °C"
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
        sunsetLabel.textColor = .black
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
        sunriseLabel.textColor = .black
        sunriseLabel.backgroundColor = .clear
        sunriseLabel.attributedText = sunriseString
        sunriseLabel.sizeToFit()
        view.addSubview(sunriseLabel)
        
        NSLayoutConstraint.activate([
            sunriseLabel.leadingAnchor.constraint(equalTo: tempLabel.leadingAnchor),
            sunriseLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor)
        ])
    }
    
    func setCurrentWeatherData(_ data: WeatherDataModel) {
        activityIndicator.startAnimating()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        tempLabel.text = "\(data.current.temp)  °C"
        guard let sunset = data.current.sunset, let sunrise = data.current.sunrise  else { return }
        sunsetString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(sunset))) ))
        sunsetLabel.attributedText = sunsetString
        sunriseString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(sunrise)))))
        sunriseLabel.attributedText = sunriseString
        
        activityIndicator.stopAnimating()
    }
    
    private func createString(for name: String) -> NSMutableAttributedString {
        let iconsSize = CGRect(x: 0, y: -5, width: 15, height: 15)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: name)
        imageAttachment.bounds = iconsSize
        let atr = NSMutableAttributedString(attachment: imageAttachment)
        
        return atr
    }
}
