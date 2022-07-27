//
//  APIModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/26/22.
//

import Foundation

class APIModel {
    private static let key = "5a0bc1288e1afcee4cf0059dbb4b654c"
    
    static func getWeatherData(lat: Float, lon: Float, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=imperial&exclude=minutely,icon&appid=\(self.key)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
    
}
