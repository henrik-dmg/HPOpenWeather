//
//  Extension.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 27.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation

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
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "BST")!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
}
