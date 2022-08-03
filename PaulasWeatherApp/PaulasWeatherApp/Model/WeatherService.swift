//
//  APIModel.swift
//  PaulasWeatherApp
//
//  Created by Stef, Paula on 7/26/22.
//

import Foundation

class WeatherService {
    private static let key = "5a0bc1288e1afcee4cf0059dbb4b654c"
    
    static func getWeatherData(lat: Float, lon: Float,time: Int, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=\(lat)&lon=\(lon)&dt=\(time)&units=metric&exclude=icon&appid=\(self.key)") else {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
    
    static func gettingWeatherIcon(iconKey: String, completionHandler:@escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(iconKey)@2x.png") else {
            return
        }
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: completionHandler)
            task.resume()
        }
    
}
