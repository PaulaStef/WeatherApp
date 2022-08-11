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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
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
    
    func filterBy( countryName: String) {
        if !countryName.isEmpty {
            displayCountries = countries.filter { $0.contains(countryName) }
        } else {
            displayCountries = countries
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

extension LocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            guard let text = textField.text
            else {
                return false
            }
            filterBy(countryName: text)
            tableView.reloadData()
            textField.resignFirstResponder()
        }
        return false
    }
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
        }
        else if indexPath.row - 1 <= displayCountries.count {
            locationManager.stopUpdatingLocation()
            let address = displayCountries[indexPath.row - 1]
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let latitude = placemarks.first?.location?.coordinate.latitude,
                    let longitude = placemarks.first?.location?.coordinate.longitude
                else {
                    print("No location found")
                    return
                }
                print("\(latitude), \(longitude)")
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
        } else if indexPath.row - 1 <= displayCountries.count {
            if !displayCountries.isEmpty {
                cell.textLabel?.text = displayCountries[indexPath.row - 1]
            }
        }
        cell.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        return cell
    }
}