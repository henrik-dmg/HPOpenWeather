//
//  OpenWeatherSwiftTests.swift
//  OpenWeatherSwiftTests
//
//  Created by Henrik Panhans on 12.02.17.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import XCTest
import OpenWeatherSwift

class OpenWeatherSwiftTests: XCTestCase {
    var api: OpenWeatherSwift!
    var forecast: Forecast!
    
    override func setUp() {
        super.setUp()
        
        api = OpenWeatherSwift(apiKey: "47768dd5aac8cb37eaaf9a13c47f156a", temperatureFormat: .Celsius)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test() {
        
    }
}
