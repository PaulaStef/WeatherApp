//
//  LocationViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/23/22.
//

import Foundation
import CoreLocation

class LocationViewModel: NSObject {
    private let notificationCenter: NotificationCenter
    private let locationManager = { () -> CLLocationManager in
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = 100.0
        return manager
    }()
    let countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func filterBy(countryName: String) -> [String] {
        if !countryName.isEmpty {
            return countries.filter { $0.contains(countryName) }
        } else {
            return countries
        }
    }
    
    // MARK: - Location methods
    func setMyLocation()  {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func setLocationFor(country: String) {
        locationManager.stopUpdatingLocation()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(country) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let lat = placemarks.first?.location?.coordinate.latitude,
                let lon = placemarks.first?.location?.coordinate.longitude else { return }
            self.setLocationDefaults(longitude: Float(lon), latitude: Float(lat))
        }
    }
    
    private func setLocationDefaults(longitude: Float, latitude: Float) {
        DefaultService.setDefaultValue(forKey: "Latitude", value: latitude)
        DefaultService.setDefaultValue(forKey: "Longitude", value: longitude)
        self.notificationCenter.post(name: .locationChanged, object: nil)
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        setLocationDefaults(longitude: Float(locValue.longitude), latitude: Float(locValue.latitude))
    }
}
