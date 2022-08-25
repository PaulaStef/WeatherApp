//
//  UnitOfMeasurmentViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/4/22.
//
import UIKit

enum UnitType: String, CaseIterable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case kelvin = "Kelvin"
}

class UnitOfMeasurmentViewController: UIViewController {
    private let picker = UIPickerView()
    private let backgroundImage = UIImageView()
    private let unitOfMeasurementViewModel: UnitOfMeasurementViewModel?
    
    init(unitOfMeasurementViewModel: UnitOfMeasurementViewModel) {
        self.unitOfMeasurementViewModel = unitOfMeasurementViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        setPicker()
        navigationItem.title = "Unit of measurement"
    }
    
    private func setPicker() {
        picker.delegate = self as UIPickerViewDelegate
        picker.dataSource = self as UIPickerViewDataSource
        self.view.addSubview(picker)
        picker.center = self.view.center
        picker.backgroundColor = .clear
        picker.frame = view.bounds
        picker.selectRow(unitOfMeasurementViewModel?.row ?? 0, inComponent: 0, animated: false)
    }
    
    private func setBackgroundImage() {
        view.addSubviewAligned(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let unitOfMeasurementViewModel = unitOfMeasurementViewModel else { return }
        unitOfMeasurementViewModel.row = pickerView.selectedRow(inComponent: component)
        unitOfMeasurementViewModel.unitTypeChanged()
    }
}
