//
//  MetricsViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class WeatherReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var hourly: [WeatherDetails] = []
    
    let tableView = UITableView()
    var refresher: UIRefreshControl = UIRefreshControl()
    
    let backgroundImage = UIImageView()
    
    override func viewDidLoad() {
        //refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "pull to refresh")
        refresher.addTarget(self, action: #selector(WeatherReportsViewController.refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refresher)
        refresh()
        
        super.viewDidLoad()
        
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
        
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
    
    func setHourlyData() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        print(hour)
        
        for i in 0..<Singleton.sharedInstance.hourlyWeather.count {
            let comingFromTheServer = TimeInterval(Singleton.sharedInstance.hourlyWeather[i].dt)
            let calendar2 = Calendar.current
            let date2 = Date(timeIntervalSince1970: comingFromTheServer)
            let hourWeather = calendar2.component(.hour, from: date2)
            print(hourWeather)
            if hour - hourWeather > 0 {
                hourly.append(Singleton.sharedInstance.hourlyWeather[i])
                //print(Singleton.sharedInstance.hourlyWeather[i].temp)
            }
        }
    }
    
    @objc func refresh() {
         setHourlyData()
         //print("refreshed")
         self.tableView.reloadData()
         self.refresher.endRefreshing()
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func showDetail(for hourlyWeather: WeatherDetails){
        let viewController = HourlyWeatherDetailsViewController(for: hourlyWeather)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourly.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked")
        let weatherDetails = hourly[indexPath.row]
        showDetail(for: weatherDetails)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let tableCell = UITableViewCell(style: .value1, reuseIdentifier: "tableCell")
        tableCell.textLabel?.text = "\(Int(round(hourly[indexPath.row].temp))) °C"
        tableCell.detailTextLabel?.attributedText = NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(hourly[indexPath.row].dt))))
        tableCell.backgroundColor = .clear
        return tableCell
    }
}


