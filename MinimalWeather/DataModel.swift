//
//  DataModel.swift
//  MinimalWeather
//
//  Created by Patientman on 2016/11/27.
//  Copyright © 2016年 mingSquall. All rights reserved.
//

import Foundation
import Alamofire



class DataModel {
    
    private var _date: Double?
    private var _location: String?
    private var _weather: String?
    private var _temp: String?
    private var _weatherImage: String?
    
    typealias JSONStandard = Dictionary<String, AnyObject>

    // convert to URL
    
    

    
    
    var date:String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
       
        let date = Date(timeIntervalSince1970: _date!)
        return (_date != nil) ? "Today, \(dateFormatter.string(from:date))" : "Date Invalid"
        
    }
    
    var temp: String {

            // 避免nil
        return _temp ?? "0 °C"

    }
    
    var location: String {
        // 避免nil
        get{
            return _location ?? "Location Invalid"
        }
        set{
            _location = location
        }
    }
    
    var weather: String {
        // 避免nil
        return _weather ?? "Weather Invalid"
    }
    
    var weatherImage: String {
        return _weatherImage ?? "Image Invalid"
    }
    
    
    
    
    func downloadData(completed: @escaping ()-> ()) {
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=beijing&appid=98b9b4ac888dd44d416398fd5d5fbfd6")!
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            
            let result = response.result
        
            if let dict = result.value as? JSONStandard,
                let main = dict["main"] as? JSONStandard,
                let temp = main["temp"] as? Double,
                let weatherArray = dict["weather"] as? [JSONStandard],
                let weatherImage = weatherArray[0]["icon"] as? String,
                let weather = weatherArray[0]["main"] as? String,
                let name = dict["name"] as? String,
                let sys = dict["sys"] as? JSONStandard,
                let country = sys["country"] as? String,
                let dt = dict["dt"] as? Double {
                
                self._temp = String(format: "%.0f °C", temp - 273.15)
                self._weather = weather
                self._location = "\(name), \(country)"
                self._date = dt
                self._weatherImage = weatherImage
            }
            
            completed()
        })
    }
    
    
}
