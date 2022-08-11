//
//  FirstDayOfTheWeekController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/4/22.
//
import UIKit

class FirstDayOfTheWeekController: UIViewController {
    
    enum DaysOfWeek: String, CaseIterable {
        case mo = "Monday"
        case tu = "Tuesday"
        case we = "Wednesday"
        case thu = "Thursday"
        case fr = "Friday"
        case sa = "Saturday"
        case su = "Sunday"
    }
    private let picker = UIPickerView()
    private var selectedRow: Int?
    weak var delegate: FirstDayOfWeekDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setPicker()
        navigationItem.title = NSLocalizedString("First day of the week", comment: "Settings view controller title")
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
            delegate?.onFirstDayOfWeekChanged(day: DaysOfWeek.allCases[selectedRow ?? 0].rawValue)
        }
    }
}

extension FirstDayOfTheWeekController: UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DaysOfWeek.allCases.count
    }
}

extension FirstDayOfTheWeekController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row <= DaysOfWeek.allCases.count {
            return DaysOfWeek.allCases[row].rawValue
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
