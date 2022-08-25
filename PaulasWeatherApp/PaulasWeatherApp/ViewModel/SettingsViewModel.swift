//
//  SettingsViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/24/22.
//

import UIKit

class SettingsViewModel: NSObject {
    var lastSelectedCell: IndexPath?
    private let firstDayOfWeekViewController: FirstDayOfTheWeekViewController?
    private let unitOfMeasurementViewController: UnitOfMeasurmentViewController?
    private let locationViewController: LocationViewController?
    
    init(firstDayOfTheWeekViewModel: FirstDayOfTheWeekViewModel, unitOfMeasurementViewModel: UnitOfMeasurementViewModel, locationViewModel: LocationViewModel) {
        firstDayOfWeekViewController = FirstDayOfTheWeekViewController(firstDayOfTheWeekViewModel: firstDayOfTheWeekViewModel)
        unitOfMeasurementViewController = UnitOfMeasurmentViewController(unitOfMeasurementViewModel: unitOfMeasurementViewModel)
        locationViewController = LocationViewController(locationViewModel: locationViewModel)
    }
    
    func settingWasSelected(navigationController: UINavigationController) {
        guard let firstDayOfWeekViewController = firstDayOfWeekViewController else {
            return
        }
        guard let unitOfMeasurementViewController = unitOfMeasurementViewController else {
            return
        }
        guard let locationViewController = locationViewController else {
            return
        }
        switch SettingsType.allCases[lastSelectedCell?.row ?? 0].rawValue {
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
}
