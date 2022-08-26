//
//  MetricsViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//

import UIKit

class WeatherReportsViewController: UIViewController {
    private let tableView = UITableView()
    private var refresher = UIRefreshControl()
    private let backgroundImage = UIImageView()
    private let notificationCenter: NotificationCenter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    private var weatherReportsViewModel: WeatherReportsViewModel?
    
    init(notificationCenter: NotificationCenter = .default, weatherReportsViewModel: WeatherReportsViewModel) {
        self.notificationCenter = notificationCenter
        self.weatherReportsViewModel = weatherReportsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onMeasurementUnitChanged), name: .unitTypeChanged, object: nil)
        bindViewModel()
        setBackgroundImage()
        setTableView()
        setRefresher()
        refresh()
    }
    
    private func bindViewModel() {
        guard let weatherReportsViewModel = weatherReportsViewModel else {
            return
        }
        weatherReportsViewModel.setHourlyWeather = {
            self.tableView.reloadData()
        }
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100) ])
    }
    
    private func setBackgroundImage() {
        view.addSubviewAligned(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    @objc func refresh() {
        self.tableView.reloadData()
        weatherReportsViewModel?.removeDataAfterCurrentTime()
        self.refresher.endRefreshing()
    }
    
    private func createTempString(temperature: Double) -> String {
        let temp = Int(round(temperature))
        let unit = String(weatherReportsViewModel?.unitType.first ?? " ")
        return "\(temp) °\(unit)"
    }
    
    @objc private func onMeasurementUnitChanged() {
        tableView.reloadData()
    }
}

// MARK: - TableView methods
extension WeatherReportsViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherReportsViewModel?.hourlyWeather.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherReportsViewModel = weatherReportsViewModel else { return UITableViewCell() }
        let temperature = weatherReportsViewModel.setNewTemperature(row: indexPath.row)
        let tableCell = UITableViewCell(style: .value1, reuseIdentifier: "tableCell")
        tableCell.textLabel?.text = createTempString(temperature: temperature)
        if indexPath.row < weatherReportsViewModel.hourlyWeather.count {
            tableCell.detailTextLabel?.attributedText = NSAttributedString(string: dateFormatter.string(from: Date(timeIntervalSince1970: Double(weatherReportsViewModel.hourlyWeather[indexPath.row].dt))))
        }
        tableCell.backgroundColor = .clear
        
        return tableCell
    }
}

extension WeatherReportsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weatherDetails = weatherReportsViewModel?.hourlyWeather[indexPath.row] else { return }
        let viewModel = HourlyWeatherViewModel(for: weatherDetails)
        let viewController = HourlyWeatherDetailsViewController(hourlyWeatherViewModel: viewModel)
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(viewController, animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
