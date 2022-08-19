//
//  MetricsViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class WeatherReportsViewController: UIViewController {
    private var hourlyWeather: [WeatherDetails] = []
    private let tableView = UITableView()
    private var refresher = UIRefreshControl()
    private let backgroundImage = UIImageView()
    private let notificationCenter: NotificationCenter
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onMeasurementUnitChanged), name: .temperatureChanged, object: nil)
        setBackgroundImage()
        setTableView()
        setRefresher()
        refresh()
    }
    
    init(notificationCenter: NotificationCenter = .default){
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setRefresher() {
        refresher.attributedTitle = NSAttributedString(string: "pull to refresh")
        refresher.addTarget(self, action: #selector(WeatherReportsViewController.refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refresher)
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.frame = view.bounds
    }
    
    private func setBackgroundImage() {
        view.addSubviewAligned(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func setHourlyData( hourlyWeather: [WeatherDetails] ) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        self.hourlyWeather.removeAll()
        for item in hourlyWeather {
            let comingFromTheServer = TimeInterval(item.dt)
            let calendar2 = Calendar.current
            let date2 = Date(timeIntervalSince1970: comingFromTheServer)
            let hourWeather = calendar2.component(.hour, from: date2)
            if hour - hourWeather > 0 {
                if !self.hourlyWeather.contains(where: { $0.dt == item.dt }){
                    self.hourlyWeather.append(item)
                }
            }
        }
    }
    
    @objc func refresh() {
        self.tableView.reloadData()
        self.refresher.endRefreshing()
    }
    
    private func createTempString(temperature: Double) -> String {
        let temp = Int(round(temperature))
        guard let unitType = defaults.string(forKey: "Unit of measurement") else { return "Error" }
        let unit = String(unitType.first ?? " ")
        return "\(temp) °\(unit)"
    }
    
    @objc private func onMeasurementUnitChanged() {
        tableView.reloadData()
    }
}

//MARK: - TableView methods
extension WeatherReportsViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourlyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let tableCell = UITableViewCell(style: .value1, reuseIdentifier: "tableCell")
        guard let unitType = defaults.string(forKey: "Unit of measurement") else { return UITableViewCell() }
        let temperature = ViewController.convert(temperature: hourlyWeather[indexPath.row].temp, to: unitType)
        tableCell.textLabel?.text = createTempString(temperature: temperature)
        tableCell.detailTextLabel?.attributedText = NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(hourlyWeather[indexPath.row].dt))))
        tableCell.backgroundColor = .clear
        
        return tableCell
    }
}

extension WeatherReportsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherDetails = hourlyWeather[indexPath.row]
        let viewController = HourlyWeatherDetailsViewController(for: weatherDetails)
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(viewController, animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
