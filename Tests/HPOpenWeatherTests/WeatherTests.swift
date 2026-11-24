import HPNetwork
import HPNetworkMock
import XCTest

@testable import HPOpenWeather

final class WeatherTests: XCTestCase {

    // MARK: - Properties

    private let apiMock = OneCallAPIMock()

    // MARK: - Test Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()
        try apiMock.mockAllEndpoints()
    }

    override func tearDown() {
        URLSessionMock.unregisterAllMockedRequests()
        super.tearDown()
    }

    // MARK: - Tests

    func testWeatherEncodingAndDecoding() async throws {
        let client = OpenWeather(apiKey: "debug")
        let weather = try await client.weather(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)

        let encodedJSON = try JSONEncoder().encode(weather)
        let decodedWeather = try JSONDecoder().decode(Weather.self, from: encodedJSON)

        XCTAssertEqual(decodedWeather, weather)
    }

    func testTimelineEncodingAndDecoding() async throws {
        let client = OpenWeather(apiKey: "debug")
        let timeline = try await client.dailyForecast(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)

        let encodedJSON = try JSONEncoder().encode(timeline)
        let decodedTimeline = try JSONDecoder().decode(WeatherTimeline<DailyForecast>.self, from: encodedJSON)

        XCTAssertEqual(decodedTimeline, timeline)
    }

}
