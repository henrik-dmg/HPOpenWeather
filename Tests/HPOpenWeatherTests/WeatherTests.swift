import HPNetwork
import XCTest

@testable import HPOpenWeather

final class WeatherTests: XCTestCase {

    func testEncoding() throws {
        let weather = try makeWeatherResponse()
        XCTAssertNoThrow(try JSONEncoder().encode(weather))
    }

    func testEncodingAndDecoding() throws {
        let weather = try makeWeatherResponse()
        let encodedJSON = try JSONEncoder().encode(weather)
        let decodedWeather = try JSONDecoder().decode(Weather.self, from: encodedJSON)

        XCTAssertEqual(decodedWeather, weather)
    }

    private func makeWeatherResponse() throws -> Weather {
        let jsonDataURL = try XCTUnwrap(
            Bundle.module.url(
                forResource: "3-0-test-response",
                withExtension: "json"
            )
        )
        let jsonData = try Data(contentsOf: jsonDataURL)

        return try JSONDecoder().decode(Weather.self, from: jsonData)
    }

}
