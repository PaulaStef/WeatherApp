//
//  LocationViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/4/22.
//
import UIKit
import CoreLocation

class LocationViewController: UIViewController {
    private let tableView = UITableView()
    private let findCountryField = UITextField()
    private let backgroundImage = UIImageView()
    private let defaults = UserDefaults.standard
    private let notificationCenter: NotificationCenter
    private var latitude: Float
    private var longitude: Float
    private let locationManager = { () -> CLLocationManager in
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = 100.0
        return manager
    }()
    var displayCountries: [String]  = []
    private let countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        latitude = defaults.float(forKey: "Latitude")
        longitude = defaults.float(forKey: "Longitude")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        navigationItem.title = "Location"
        displayCountries = countries
        setFindCountryField()
        setTableView()
    }
    
    private func setFindCountryField() {
        view.addSubview(findCountryField)
        findCountryField.textAlignment = .center
        findCountryField.backgroundColor = .separator
        findCountryField.attributedPlaceholder = NSAttributedString(string: "Search Country")
        findCountryField.translatesAutoresizingMaskIntoConstraints = false
        findCountryField.becomeFirstResponder()
        findCountryField.delegate = self
        findCountryField.tag = 1
        NSLayoutConstraint.activate([
            findCountryField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            findCountryField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            findCountryField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            findCountryField.heightAnchor.constraint(equalToConstant: 60) ])
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: findCountryField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setBackgroundImage() {
        view.addSubviewAligned(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func filterBy(countryName: String) {
        if !countryName.isEmpty {
            displayCountries = countries.filter { $0.contains(countryName) }
        } else {
            displayCountries = countries
        }
    }
}

//MARK: - Location Methods
extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        defaults.set(Float(locValue.latitude), forKey: "Latitude")
        defaults.set(Float(locValue.longitude), forKey: "Longitude")
        notificationCenter.post(name: .locationChanged, object: nil)
    }
}

extension LocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            guard let text = textField.text else { return false }
            filterBy(countryName: text)
            tableView.reloadData()
            textField.resignFirstResponder()
        }
        return false
    }
}

//MARK: - TableView Methods
extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0, CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else if indexPath.row - 1 < displayCountries.count {
            locationManager.stopUpdatingLocation()
            let address = displayCountries[indexPath.row - 1]
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let lat = placemarks.first?.location?.coordinate.latitude,
                    let lon = placemarks.first?.location?.coordinate.longitude else { return }
                self.defaults.set(Float(lat), forKey: "Latitude")
                self.defaults.set(Float(lon), forKey: "Longitude")
                self.notificationCenter.post(name: .locationChanged, object: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayCountries.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if indexPath.row == 0 {
            cell.textLabel?.text = "Your location"
        } else if indexPath.row - 1 < displayCountries.count {
            if !displayCountries.isEmpty {
                cell.textLabel?.text = displayCountries[indexPath.row - 1]
            }
        }
        cell.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
}
