//
//  WeatherViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    var tempLabel: UILabel = UILabel()
    var sunriseLabel: UILabel = UILabel()
    var sunsetLabel: UILabel = UILabel()
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var sunriseString: NSMutableAttributedString = {
        let iconsSize = CGRect(x: 0, y: -5, width: 15, height: 15)
        let sunriseAttachment = NSTextAttachment()
        sunriseAttachment.image = UIImage(systemName: "sunrise")
        sunriseAttachment.bounds = iconsSize
        let atr = NSMutableAttributedString(attachment: sunriseAttachment)
        return atr
    }()
    
    var sunsetString: NSMutableAttributedString = {
        let iconsSize = CGRect(x: 0, y: -5, width: 15, height: 15)
        let sunsetAttachment = NSTextAttachment()
        sunsetAttachment.image = UIImage(systemName: "sunset")
        sunsetAttachment.bounds = iconsSize
        let atr = NSMutableAttributedString(attachment: sunsetAttachment)
        return atr
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        setCurrentWeatherViews()
        view.backgroundColor = .systemRed
    }
    
    func setCurrentWeatherViews(){
        
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.textAlignment = .center
        tempLabel.font = .systemFont(ofSize: 36)
        tempLabel.textColor = .black
        tempLabel.text = "... °C"
        tempLabel.backgroundColor = .clear
        tempLabel.sizeToFit()
        
        sunriseLabel.translatesAutoresizingMaskIntoConstraints = false
        sunriseLabel.textAlignment = .center
        sunriseLabel.font = .systemFont(ofSize: 12)
        sunriseLabel.textColor = .black
        sunriseLabel.backgroundColor = .clear
        sunriseLabel.attributedText = sunriseString
        sunriseLabel.sizeToFit()
        
        sunsetLabel.translatesAutoresizingMaskIntoConstraints = false
        sunsetLabel.textAlignment = .center
        sunsetLabel.font = .systemFont(ofSize: 12)
        sunsetLabel.textColor = .black
        sunsetLabel.backgroundColor = .clear
        sunsetLabel.attributedText = sunsetString
        sunsetLabel.sizeToFit()
        
        self.view.addSubview(tempLabel)
        self.view.addSubview(sunsetLabel)
        self.view.addSubview(sunriseLabel)
        
        NSLayoutConstraint.activate([
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            
            sunriseLabel.leadingAnchor.constraint(equalTo: tempLabel.leadingAnchor),
            sunriseLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            
            sunsetLabel.leadingAnchor.constraint(equalTo: sunriseLabel.trailingAnchor,constant: 10),
            sunsetLabel.trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor),
            sunsetLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            
            ])
    }
    
    func setCurrentWeatherData(_ data : WeatherDataModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        tempLabel.text = "\(data.current.temp)  °C"
        guard let sunset = data.current.sunset else { return }
        guard let sunrise = data.current.sunrise else { return }
        
        sunsetString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(sunset))) ))
        sunsetLabel.attributedText = sunsetString
        
        sunriseString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970:Double(sunrise)))))
        sunriseLabel.attributedText = sunriseString

        
        
       
    }
    
}
