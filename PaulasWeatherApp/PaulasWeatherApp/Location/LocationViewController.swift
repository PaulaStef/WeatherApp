//
//  LocationViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/4/22.
//
import UIKit

class LocationViewController: UIViewController {
    private let tableView = UITableView()
    private let findCountryField = UITextField()
    private let backgroundImage = UIImageView()
    private let locationViewModel: LocationViewModel?
    var displayCountries: [String]  = []
    
    init(notificationCenter: NotificationCenter = .default, locationViewModel: LocationViewModel) {
        self.locationViewModel = locationViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        navigationItem.title = "Location"
        displayCountries = locationViewModel?.countries ?? []
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
}

// MARK: - Search Country Method
extension LocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            guard let text = textField.text else { return false }
            displayCountries = locationViewModel?.filterBy(countryName: text) ?? []
            tableView.reloadData()
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - TableView Methods
extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let locationViewModel = locationViewModel else { return }
        if indexPath.row == 0 {
            locationViewModel.setMyLocation()
        } else if indexPath.row - 1 < displayCountries.count {
            locationViewModel.setLocationFor(country: displayCountries[indexPath.row - 1])
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
