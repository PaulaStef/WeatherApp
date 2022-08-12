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
    weak var delegate: MeasurementsDelegate?
    private let defaults = UserDefaults.standard
    private let backgroundImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        setPicker()
        navigationItem.title = NSLocalizedString("Unit of Measurment", comment: "Unit of measurment view controller title")
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.onMeasurementUnitChanged()
        }
    }
}

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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let selectedRow = pickerView.selectedRow(inComponent: component)
        defaults.set(selectedRow, forKey: "Selected unit row")
        defaults.set(UnitType.allCases[selectedRow].rawValue, forKey: "Unit of measurement")
    }
}
