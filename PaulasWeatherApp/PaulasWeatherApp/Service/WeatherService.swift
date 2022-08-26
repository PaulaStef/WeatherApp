//
//  APIModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/26/22.
//

import Foundation

class WeatherService {
    private let key = "5a0bc1288e1afcee4cf0059dbb4b654c"
    
    func getWeatherData(lat: Double, lon: Double, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=icon&appid=\(key)") else {
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
}
