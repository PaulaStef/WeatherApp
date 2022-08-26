//
//  SettingsViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/25/22.
//
import UIKit

enum SettingsType: String, CaseIterable {
    case firstDay = "First day of the week"
    case unit = "Unit of measurement"
    case location = "Location"
}

class SettingsViewController: UIViewController {
    private let tableView = UITableView()
    private let notificationCenter: NotificationCenter
    private var settingsViewModel: SettingsViewModel?
    private let backgroundImage = UIImageView()
    
    init(notificationCenter: NotificationCenter = .default, settingsViewModel: SettingsViewModel){
        self.notificationCenter = notificationCenter
        self.settingsViewModel = settingsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(onMeasurementUnitChanged), name: .unitTypeChanged, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onFirstDayOfWeekChanged), name: .firstDayOfWeekChanged, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onLocationChanged), name: .locationChanged, object: nil)
        setBackgroundImage()
        setTableView()
        settingsViewModel?.lastSelectedCell = tableView.indexPathsForSelectedRows?[0]
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
    
// MARK: - NotificationCenter methods
    @objc func onMeasurementUnitChanged() {
        guard let index = settingsViewModel?.lastSelectedCell else { return }
        let unit = DefaultService.getDefaultStringValue(forKey: "Unit of measurement")
        tableView.cellForRow(at: index)?.detailTextLabel?.text = unit
    }
    
    @objc func onFirstDayOfWeekChanged() {
        guard let index = settingsViewModel?.lastSelectedCell else { return }
        let day = DefaultService.getDefaultStringValue(forKey: "First day of the week")
        tableView.cellForRow(at: index)?.detailTextLabel?.text = day
    }
    
    @objc func onLocationChanged() {
        guard let index = settingsViewModel?.lastSelectedCell else { return }
        let location = DefaultService.getDefaultStringValue(forKey: "Location")
        tableView.cellForRow(at: index)?.detailTextLabel?.text = location
    }
}

// MARK: - TableView methods
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsViewModel?.lastSelectedCell = indexPath
        guard let navigationController = navigationController else { return }
        if indexPath.row <= SettingsType.allCases.count {
            settingsViewModel?.settingWasSelected(navigationController: navigationController)
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
        if indexPath.row <= SettingsType.allCases.count {
            let settingType = SettingsType.allCases[indexPath.row]
            cell.textLabel?.text = settingType.rawValue
            cell.detailTextLabel?.text = DefaultService.getDefaultStringValue(forKey: settingType.rawValue)
        }
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
