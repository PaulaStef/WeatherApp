//
//  FirstDayOfTheWeekViewModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/24/22.
//

import Foundation

class FirstDayOfTheWeekViewModel: NSObject {
    var row: Int
    private let notificationCenter: NotificationCenter
    private let defaults = UserDefaults.standard
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        row = defaults.integer(forKey: "Selected first day row")
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func firstDayOfTheWeekChanged() {
        defaults.set(row, forKey: "Selected first day row")
        defaults.set(DaysOfWeek.allCases[row].rawValue, forKey: "First day of the week")
        notificationCenter.post(name: .firstDayOfWeekChanged, object: nil)
    }
}
