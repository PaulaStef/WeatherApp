//
//  NotificationName.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/17/22.
//

import Foundation

extension Notification.Name {
    static var unitTypeChanged: Notification.Name {
        return .init(rawValue: "UnitOfMeasurment.changed")
    }
    
    static var firstDayOfWeekChanged: Notification.Name {
        return .init(rawValue: "FirstDayOfTheWeek.changed")
    }
    
    static var locationChanged: Notification.Name {
        return .init(rawValue: "Location.changed")
    }
}
