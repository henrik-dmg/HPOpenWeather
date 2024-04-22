import XCTest

@testable import HPOpenWeather

final class WeatherIconTests: XCTestCase {

    func testAllSystemImages() {
        for icon in WeatherIcon.allCases {
            XCTAssertNotNil(icon.filledNSImage())
        }
    }

}
