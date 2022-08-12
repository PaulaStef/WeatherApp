//
//  SettingsViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//
import UIKit

class SettingsViewController: UIViewController {
    
    enum SettingsType: String, CaseIterable {
        case firstDay = "First day of the week"
        case unit = "Unit of measurement"
        case location = "Location"
    }
    private let tableView = UITableView()
    private var lastSelectedCell: IndexPath?
    private let firstDayOfWeekViewController = FirstDayOfTheWeekController()
    private let unitOfMeasurementViewController = UnitOfMeasurmentViewController()
    private let locationViewController = LocationViewController()
    private let defaults = UserDefaults.standard
    private let backgroundImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        setTableView()
        lastSelectedCell = tableView.indexPathsForSelectedRows?[0]
        firstDayOfWeekViewController.delegate = self
        unitOfMeasurementViewController .delegate = self
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
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedCell = indexPath
        guard let navigationController = navigationController else { return }
        if indexPath.row <= SettingsType.allCases.count {
            switch SettingsType.allCases[indexPath.row].rawValue {
            case "First day of the week":
                navigationController.pushViewController(firstDayOfWeekViewController, animated: false)
            case "Unit of measurement":
                navigationController.pushViewController(unitOfMeasurementViewController, animated: false)
            case "Location":
                navigationController.pushViewController(locationViewController, animated: false)
            default:
                print("You have done something wrong")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        if indexPath.row <= SettingsType.allCases.count{
            let settingType = SettingsType.allCases[indexPath.row]
            cell.textLabel?.text = settingType.rawValue
            cell.detailTextLabel?.text = defaults.string(forKey: settingType.rawValue)
        }
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension SettingsViewController: MeasurementsDelegate {
    func onMeasurementUnitChanged() {
        guard let index = lastSelectedCell else { return }
        guard let unit = defaults.string(forKey: "Unit of measurement") else { return }
        tableView.cellForRow(at: index)?.detailTextLabel?.text = unit
    }
}

extension SettingsViewController: FirstDayOfWeekDelegate{
    func onFirstDayOfWeekChanged() {
        guard let index = lastSelectedCell else { return }
        guard let day = defaults.string(forKey: "First day of the week") else { return }
        tableView.cellForRow(at: index)?.detailTextLabel?.text = day
    }
}
