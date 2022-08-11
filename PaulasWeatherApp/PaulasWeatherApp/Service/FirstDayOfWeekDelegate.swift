//
//  FirstDayOfWeekDelegate.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 8/11/22.
//

import Foundation

protocol FirstDayOfWeekDelegate: AnyObject {
    func onFirstDayOfWeekChanged(day: String)
}
