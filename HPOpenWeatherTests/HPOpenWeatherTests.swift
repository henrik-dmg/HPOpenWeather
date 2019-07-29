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

    var api: HPOpenWeather?
    
    override func setUp() {
        
        // TODO: Insert your own API key here
        api = HPOpenWeather(apiKey: "5d254ac1b2cb8ecd6f603cbfac3aaea0", temperatureFormat: .celsius, language: .english)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        api = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherIcon() {
        let mockIcon = WeatherIcon.clearSky
        let testIcon = WeatherIcon(from: "01d")
        let failingIcon = WeatherIcon(from: "12d")

        XCTAssertNotNil(testIcon)
        XCTAssertNil(failingIcon)
        XCTAssert(mockIcon == testIcon)
    }
    
    func testInvalidApiKey() {
        api = HPOpenWeather(apiKey: "invalidKey", temperatureFormat: .celsius, language: .english)

        let request = CityNameRequest("Berlin", countryCode: "DE")
        let promise = expectation(description: "Simple Request")

        api?.requestCurrentWeather(with: request) { (current, error) in
            if let error = error as NSError? {
                XCTAssert(error.code == 401)
            }

            promise.fulfill()
        }

        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testIconCache() {
        DispatchQueue.concurrentPerform(iterations: 10) { (index) in
            print("Iteration: \(index)")
            api?.getIconWith(id: "01d.png", completion: { (image) in
            })
        }
    }
    
    func testQueryItems() {
        let firstItems = [URLQueryItem(name: "test1", value: "firstTestString"),
                          URLQueryItem(name: "test2", value: "firstTestString2"),
                          URLQueryItem(name: "test3", value: "firstTestString3")]
        
        let secondItems = [URLQueryItem(name: "test3", value: "firstTestString3"),
                          URLQueryItem(name: "test4", value: "firstTestString4"),
                          URLQueryItem(name: "test5", value: "firstTestString5")]
        
        var url = URL(string: "https://panhans.dev")!
        url.add(firstItems)
        url.add(secondItems)
        
        let components = URLComponents(string: url.absoluteString)
        
        XCTAssert(components?.queryItems?.count == 5)
    }
    
    func testCurrentWeather() {
        let request = CityNameRequest("Berlin", countryCode: "DE")
        let promise = expectation(description: "Simple Request")
        
        api?.requestCurrentWeather(with: request) { (current, error) in
            XCTAssertNil(error)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testForecast() {
        let request = CityNameRequest("Berlin", countryCode: "DE")
        let promise = expectation(description: "Simple Forecast")
        
        api?.requestHourlyForecast(with: request, for: .threeHourly) { (forecast, error) in
            XCTAssertNil(error)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}
