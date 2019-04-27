//
//  HPOpenWeatherTests.swift
//  HPOpenWeatherTests
//
//  Created by Henrik Panhans on 26.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import XCTest
@testable import HPOpenWeather

class HPOpenWeatherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testQueryItems() {
        let firstItems = [URLQueryItem(name: "test1", value: "firstTestString"),
                          URLQueryItem(name: "test2", value: "firstTestString2"),
                          URLQueryItem(name: "test3", value: "firstTestString3")]
        
        let secondItems = [URLQueryItem(name: "test3", value: "firstTestString3"),
                          URLQueryItem(name: "test4", value: "firstTestString4"),
                          URLQueryItem(name: "test5", value: "firstTestString5")]
        
        var url = HPOpenWeather.baseURL.url()
        url.add(firstItems)
        url.add(secondItems)
        
        let components = URLComponents(string: url.absoluteString)
        
        XCTAssert(components?.queryItems?.count == 5)
    }
}
