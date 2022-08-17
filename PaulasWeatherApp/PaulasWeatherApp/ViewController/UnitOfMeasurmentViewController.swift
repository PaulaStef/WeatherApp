//
//  UnitOfMeasurmentViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/4/22.
//
import UIKit

class UnitOfMeasurmentViewController: UIViewController {
    
    enum UnitType: String, CaseIterable {
        case celsius = "Celsius"
        case fahrenheit = "Fahrenheit"
        case kelvin = "Kelvin"
    }
    private let picker = UIPickerView()
    private let notificationCenter: NotificationCenter
    private let defaults = UserDefaults.standard
    private let backgroundImage = UIImageView()
    private var unit: UnitType {
        didSet{
            notificationCenter.post(name: .temperatureChanged, object: nil)
        }
    }
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        let unitName = defaults.string(forKey: "Unit of measurement") ?? "Celsius"
        unit = UnitType.init(rawValue: unitName) ?? UnitType.celsius
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        setPicker()
        navigationItem.title = "Unit of measurment"
    }
    
    private func setPicker() {
        picker.delegate = self as UIPickerViewDelegate
        picker.dataSource = self as UIPickerViewDataSource
        self.view.addSubview(picker)
        picker.center = self.view.center
        picker.backgroundColor = .clear
        picker.frame = view.bounds
        let row = defaults.integer(forKey: "Selected unit row")
        picker.selectRow(row, inComponent: 0, animated: false)
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

// MARK: - Picker methods
extension UnitOfMeasurmentViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UnitType.allCases.count
    }
}

extension UnitOfMeasurmentViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row <= UnitType.allCases.count {
            return UnitType.allCases[row].rawValue
        } else {
            return "Error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let selectedRow = pickerView.selectedRow(inComponent: component)
        defaults.set(selectedRow, forKey: "Selected unit row")
        defaults.set(UnitType.allCases[selectedRow].rawValue, forKey: "Unit of measurement")
        unit = UnitType.allCases[selectedRow]
    }
}
