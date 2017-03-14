//
//  Weather.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 16/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import SwiftyJSON

public class Weather {
    public var humidity: Int
    public var id: Int
    public var clouds: Float
    public var country: String
    public var visibility: Int
    public var airPressure: Int
    
    public var temperature: Int
    public var low: Int
    public var high: Int
    public var location: String
    public var condition: String
    public var icon: String
    
    
    public init(data: JSON) {
        self.humidity = data["main"]["humidity"].intValue
        self.id = data["id"].intValue
        self.clouds = data["clouds"]["all"].floatValue
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

public extension String {
    func convertToDate(withFormat: String) -> Date {
        TimeZone.ReferenceType.default = TimeZone(abbreviation: "BST")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        dateFormatter.dateFormat = withFormat
        
        return dateFormatter.date(from: self)!
    }
}

public extension Date {
    func convertToString() -> String {
        TimeZone.ReferenceType.default = TimeZone(abbreviation: "BST")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
}

