//
//  WeatherViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    var tempLabel : UILabel = UILabel()
    var sunriseLabel : UILabel = UILabel()
    var sunsetLabel : UILabel = UILabel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemRed
    }
    
    func setCurrentWeatherUI(_ data : WeatherDataModel){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.textAlignment = .center
        tempLabel.font = .systemFont(ofSize: 36)
        tempLabel.textColor = .black
        tempLabel.text = "\(data.current.temp) °C"
        tempLabel.backgroundColor = .clear
        tempLabel.sizeToFit()
        
        let iconsSize = CGRect(x: 0, y: -5, width: 15, height: 15)
        
        let sunriseAttachment = NSTextAttachment()
        sunriseAttachment.image = UIImage(systemName: "sunrise")
        sunriseAttachment.bounds = iconsSize
        
        let sunriseString = NSMutableAttributedString(attachment: sunriseAttachment)
        sunriseString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970:Double(data.current.sunrise!)))))
        
        sunriseLabel.translatesAutoresizingMaskIntoConstraints = false
        sunriseLabel.textAlignment = .center
        sunriseLabel.font = .systemFont(ofSize: 12)
        sunriseLabel.textColor = .black
        sunriseLabel.backgroundColor = .clear
        sunriseLabel.attributedText = sunriseString
        //sunriseLabel.sizeToFit()
        
        let sunsetAttachment = NSTextAttachment()
        sunsetAttachment.image = UIImage(systemName: "sunset")
        sunsetAttachment.bounds = iconsSize
        
        let sunsetString = NSMutableAttributedString(attachment: sunsetAttachment)
        sunsetString.append(NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(data.current.sunset!))) ))
        sunsetLabel.translatesAutoresizingMaskIntoConstraints = false
        sunsetLabel.textAlignment = .center
        sunsetLabel.font = .systemFont(ofSize: 12)
        sunsetLabel.textColor = .black
        sunsetLabel.backgroundColor = .clear
        sunsetLabel.attributedText = sunsetString
        //sunsetLabel.sizeToFit()
        
        self.view.addSubview(tempLabel)
        self.view.addSubview(sunsetLabel)
        self.view.addSubview(sunriseLabel)
        
        NSLayoutConstraint.activate([
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            
            sunriseLabel.leadingAnchor.constraint(equalTo: tempLabel.leadingAnchor),
            sunriseLabel.trailingAnchor.constraint(equalTo: sunsetLabel.leadingAnchor, constant: -10),
            sunriseLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            
            sunsetLabel.leadingAnchor.constraint(equalTo: sunriseLabel.trailingAnchor),
            sunsetLabel.trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: -10),
            sunsetLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            
            ])
        
    }
    
}
