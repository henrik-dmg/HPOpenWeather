import HPNetwork
import HPNetworkMock
import XCTest

@testable import HPOpenWeather

final class OpenWeatherTests: XCTestCase {

    // MARK: - Properties

    private lazy var mockedURLSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLSessionMock.self]
        return URLSession(configuration: configuration)
    }()

    // MARK: - Test Lifecycle

    override func tearDown() {
        URLSessionMock.unregisterAllMockedRequests()
        super.tearDown()
    }

    // MARK: - Tests

    func testNewApiRequest() async throws {
        try makeWeatherResponse()

        let settings = OpenWeather.Settings(apiKey: "debug")
        let request = WeatherRequest(
            coordinate: .init(latitude: 52.5200, longitude: 13.4050),
            excludedFields: nil,
            date: nil,
            settings: settings
        )
        let weather = try await request.response(urlSession: mockedURLSession).output

        let currentWeather = try XCTUnwrap(weather.currentWeather)
        XCTAssertEqual(currentWeather.timestamp, Date(timeIntervalSince1970: 1_713_795_125))
        XCTAssertEqual(weather.units, .metric)
    }

    func testInvalidApiKey() async throws {
        let settings = OpenWeather.Settings(apiKey: "debug")
        let request = WeatherRequest(
            coordinate: .init(latitude: 52.5200, longitude: 13.4050),
            excludedFields: nil,
            date: nil,
            settings: settings
        )

        do {
            _ = try await request.response(urlSession: .shared).output
        } catch {
            let apiError = try XCTUnwrap(error as? OpenWeatherAPIError)
            XCTAssertEqual(apiError.code, 401)
        }
    }

    func testInvalidTimeMachineTimestamp() async throws {
        let settings = OpenWeather.Settings(apiKey: "debug")
        let request = WeatherRequest(
            coordinate: .init(latitude: 52.5200, longitude: 13.4050),
            excludedFields: nil,
            date: Date.distantFuture,
            settings: settings
        )

        do {
            _ = try await request.response(urlSession: .shared).output
        } catch {
            let apiError = try XCTUnwrap(error as? OpenWeatherError)
            XCTAssertEqual(apiError, .invalidRequestTimestamp)
        }
    }

    // MARK: - Helpers

    private func makeWeatherResponse() throws {
        let url = try XCTUnwrap(URL(string: "https://api.openweathermap.org/data/3.0/onecall"))
        let jsonDataURL = try XCTUnwrap(
            Bundle.module.url(
                forResource: "3-0-test-response",
                withExtension: "json"
            )
        )
        let jsonData = try Data(contentsOf: jsonDataURL)

        _ = URLSessionMock.mockRequest(to: url, ignoresQuery: true) { _ in
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": ContentType.applicationJSON.rawValue]
            )!
            return (jsonData, response)
        }
    }

}
