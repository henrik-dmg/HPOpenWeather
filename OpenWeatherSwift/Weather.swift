//
//  Weather.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 16/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import SwiftyJSON

public struct Weather {
    var humidity: Int
    var id: Int
    var clouds: Float
    var country: String
    var visibility: Int
    var airPressure: Int
    
    var temperature: Int
    var low: Int
    var high: Int
    var location: String
    var condition: String
    var icon: String
    
    init(data: JSON) {
        self.humidity = data["main"]["humidity"].intValue
        self.id = data["id"].intValue
        self.clouds = 100/data["clouds"]["all"].floatValue
        self.country = data["sys"]["country"].stringValue
        self.visibility = data["visibility"].intValue
        self.airPressure = data["main"]["pressure"].intValue
        self.temperature = data["main"]["temp"].intValue
        self.low = data["main"]["temp_min"].intValue
        self.high = data["main"]["temp_max"].intValue
        self.location = data["name"].stringValue
        self.condition = data["weather"][0]["main"].stringValue
        self.icon = data["weather"][0]["icon"].stringValue
    }
}

extension Double {
    func convertTimeToString() -> String {
        let currentDateTime = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM hh:mm"
        return dateFormatter.string(from: currentDateTime)
    }
}
