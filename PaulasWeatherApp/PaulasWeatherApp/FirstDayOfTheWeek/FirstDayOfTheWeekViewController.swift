//
//  FirstDayOfTheWeekViewController.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/4/22.
//
import UIKit

enum DaysOfWeek: String, CaseIterable {
    case mo = "Monday"
    case tu = "Tuesday"
    case we = "Wednesday"
    case thu = "Thursday"
    case fr = "Friday"
    case sa = "Saturday"
    case su = "Sunday"
}

class FirstDayOfTheWeekViewController: UIViewController {
    private let picker = UIPickerView()
    private let backgroundImage = UIImageView()
    private var firstDayOfTheWeekViewModel: FirstDayOfTheWeekViewModel?
    
    init(firstDayOfTheWeekViewModel: FirstDayOfTheWeekViewModel) {
        self.firstDayOfTheWeekViewModel = firstDayOfTheWeekViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        picker.selectRow(firstDayOfTheWeekViewModel?.row ?? 0, inComponent: 0, animated: false)
    }
    
    private func setBackgroundImage() {
        view.addSubviewAligned(backgroundImage)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
}

// MARK: - PickerView methods
extension FirstDayOfTheWeekViewController: UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DaysOfWeek.allCases.count
    }
}

extension FirstDayOfTheWeekViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row <= DaysOfWeek.allCases.count {
            return DaysOfWeek.allCases[row].rawValue
        } else {
            return "Error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let firstDayOfTheWeekViewModel = firstDayOfTheWeekViewModel else { return }
        firstDayOfTheWeekViewModel.row = pickerView.selectedRow(inComponent: component)
        firstDayOfTheWeekViewModel.firstDayOfTheWeekChanged()
    }
}
