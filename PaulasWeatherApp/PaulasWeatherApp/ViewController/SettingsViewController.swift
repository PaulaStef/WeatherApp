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
    private let notificationCenter: NotificationCenter
    private let defaults = UserDefaults.standard
    private let backgroundImage = UIImageView()
    
    init(notificationCenter: NotificationCenter = .default){
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onMeasurementUnitChanged), name: .temperatureChanged, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onFirstDayOfWeekChanged), name: .firstDayOfWeekChanged, object: nil)
        setBackgroundImage()
        setTableView()
        lastSelectedCell = tableView.indexPathsForSelectedRows?[0]
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
    
// MARK: - NotificationCenter methods
    @objc func onMeasurementUnitChanged() {
        guard let index = lastSelectedCell else { return }
        guard let unit = defaults.string(forKey: "Unit of measurement") else { return }
        tableView.cellForRow(at: index)?.detailTextLabel?.text = unit
    }
    
    @objc func onFirstDayOfWeekChanged() {
        guard let index = lastSelectedCell else { return }
        guard let day = defaults.string(forKey: "First day of the week") else { return }
        tableView.cellForRow(at: index)?.detailTextLabel?.text = day
    }
}

// MARK: - TableView methods
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
