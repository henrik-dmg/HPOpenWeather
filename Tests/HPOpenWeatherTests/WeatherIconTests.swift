import XCTest
@testable import HPOpenWeather

final class WeatherIconTests: XCTestCase {

	#if canImport(AppKit)
	@available(OSX 11.0, *)
	func testAllSystemImages() {
		WeatherIcon.allCases.forEach {
			XCTAssertNotNil($0.filledNSImage())
		}
	}
	#endif

	#if canImport(UIKit)
	@available(iOS 13.0, *)
	func testAllSystemImages() {
		WeatherIcon.allCases.forEach {
			XCTAssertNotNil($0.filledUIImage())
		}
	}
	#endif

}
