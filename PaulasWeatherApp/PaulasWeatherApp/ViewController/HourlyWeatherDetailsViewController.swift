//
//  HourlyWeatherDetailsViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/1/22.
//
import UIKit

enum DetailsHourly: String, CaseIterable {
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
    private let notificationCenter: NotificationCenter
    private let temperatureLabel = UILabel()
    private let backgroundImage = UIImageView()
    private let hourlyWeatherViewModel: HourlyWeatherViewModel?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HourlyWeatherDetailsCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    init(notificationCenter: NotificationCenter = .default, hourlyWeatherViewModel: HourlyWeatherViewModel) {
        self.hourlyWeatherViewModel = hourlyWeatherViewModel
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onMeasurementUnitChanged), name: .unitTypeChanged, object: nil)
        setBackgroundImage()
        setTemperatureLabel()
        setCollectionView()
    }
    
    private func setTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.textAlignment = .center
        view.addSubview(temperatureLabel)
        temperatureLabel.backgroundColor = .clear
        temperatureLabel.text = "\(hourlyWeatherViewModel?.temperature ?? 0) °\(hourlyWeatherViewModel?.unitType.first ?? "C")"
        temperatureLabel.font = .systemFont(ofSize: 42)
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            temperatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 150) ])
    }
    
    private func setBackgroundImage() {
        view.addSubviewAligned(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
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
        
    @objc private func onMeasurementUnitChanged() {
        hourlyWeatherViewModel?.setNewTemperature()
        collectionView.reloadData()
    }
}

//MARK: - CollectionView methods
extension HourlyWeatherDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HourlyWeatherDetailsCell
        else {
            return  UICollectionViewCell()
        }
        if indexPath.row < DetailsHourly.allItems.count{
            let detail = DetailsHourly.allItems[indexPath.row]
            cell.titleLabel.text = "\(detail.rawValue)"
            cell.descriptionLabel.text = hourlyWeatherViewModel?.getValue(for: detail)
        }
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = collectionView.backgroundView
        
        return cell
    }
}

extension HourlyWeatherDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DetailsHourly.allCases.count
    }
}
