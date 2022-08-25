//
//  UnitOfMeasurementViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/24/22.
//

import Foundation

class UnitOfMeasurementViewModel: NSObject {
    private let notificationCenter: NotificationCenter
    var row : Int
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        row = DefaultService.getDefaultIntValue(forKey: "Selected unit row")
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unitTypeChanged() {
        DefaultService.setDefaultValue(forKey: "Selected unit row", value: row)
        DefaultService.setDefaultValue(forKey: "Unit of measurement", value: UnitType.allCases[row].rawValue)
        notificationCenter.post(name: .unitTypeChanged, object: nil)
    }
}
