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
    private var selectedRow: Int?
    weak var delegate: MeasurementsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.onMeasurementUnitChanged(unit: UnitType.allCases[selectedRow ?? 0].rawValue)
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
        }
        else {
            return "Error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedRow = pickerView.selectedRow(inComponent: component)
    }
}
