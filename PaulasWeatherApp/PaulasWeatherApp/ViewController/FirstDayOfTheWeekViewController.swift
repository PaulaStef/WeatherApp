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
    weak var delegate: FirstDayOfWeekDelegate?
    private let defaults = UserDefaults.standard
    private let backgroundImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        setPicker()
        navigationItem.title = "First day of the week"
    }
    
    private func setPicker() {
        picker.delegate = self as UIPickerViewDelegate
        picker.dataSource = self as UIPickerViewDataSource
        self.view.addSubview(picker)
        picker.center = self.view.center
        picker.backgroundColor = .clear
        picker.frame = view.bounds
        let row = defaults.integer(forKey: "Selected first day row")
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
            delegate?.onFirstDayOfWeekChanged()
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
        } else {
            return "Error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRow = pickerView.selectedRow(inComponent: component)
        defaults.set(selectedRow, forKey: "Selected first day row")
        defaults.set(DaysOfWeek.allCases[selectedRow].rawValue, forKey: "First day of the week")
    }
}
