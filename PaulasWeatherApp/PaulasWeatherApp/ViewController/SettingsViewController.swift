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
    private let initialValues = ["Mo", "C", ""]
    private let tableView = UITableView()
    private var lastSelectedCell: IndexPath?
    private let firstDayOfWeekViewController = FirstDayOfTheWeekController()
    private let unitOfMeasurementViewController = UnitOfMeasurmentViewController()
    private let locationViewController = LocationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
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
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedCell = indexPath
        guard let navigationController = navigationController
        else {
            return
        }
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
            cell.textLabel?.text = SettingsType.allCases[indexPath.row].rawValue
            cell.detailTextLabel?.text = initialValues[indexPath.row]
        }
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension SettingsViewController: MeasurementsDelegate {
    func onMeasurementUnitChanged(unit: String) {
        guard let index = lastSelectedCell else { return }
        print(unit)
        tableView.cellForRow(at: index)?.detailTextLabel?.text = String(unit.first ?? " ")
    }
}

extension SettingsViewController: FirstDayOfWeekDelegate{
    func onFirstDayOfWeekChanged(day: String) {
        guard let index = lastSelectedCell else { return }
        print(day)
        tableView.cellForRow(at: index)?.detailTextLabel?.text = String(day.prefix(2))
    }
}
