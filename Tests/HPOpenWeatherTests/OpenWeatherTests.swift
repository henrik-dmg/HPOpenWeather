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

    func testOldApiRequest() async throws {
        try make25WeatherResponse(version: .twoPointFive)

        let settings = OpenWeather.Settings(apiKey: "debug")
        let request = WeatherRequest(
            coordinate: .init(latitude: 52.5200, longitude: 13.4050),
            excludedFields: nil,
            date: nil,
            settings: settings,
            version: .twoPointFive
        )
        _ = try await request.response(urlSession: mockedURLSession)
    }

    func testNewApiRequest() async throws {
        try make25WeatherResponse(version: .threePointZero)

        let settings = OpenWeather.Settings(apiKey: "debug")
        let request = WeatherRequest(
            coordinate: .init(latitude: 52.5200, longitude: 13.4050),
            excludedFields: nil,
            date: nil,
            settings: settings,
            version: .threePointZero
        )
        let weather = try await request.response(urlSession: mockedURLSession).output

        let currentWeather = try XCTUnwrap(weather.currentWeather)
        XCTAssertEqual(currentWeather.timestamp, Date(timeIntervalSince1970: 1_713_795_125))
    }

    func testInvalidApiKey() async throws {
        let settings = OpenWeather.Settings(apiKey: "debug")
        let request = WeatherRequest(
            coordinate: .init(latitude: 52.5200, longitude: 13.4050),
            excludedFields: nil,
            date: nil,
            settings: settings,
            version: .threePointZero
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
            settings: settings,
            version: .threePointZero
        )

        do {
            _ = try await request.response(urlSession: .shared).output
        } catch {
            let apiError = try XCTUnwrap(error as? OpenWeatherError)
            XCTAssertEqual(apiError, .invalidRequestTimestamp)
        }
    }

    // MARK: - Helpers

    private func make25WeatherResponse(version: OpenWeather.APIVersion) throws {
        let url = try XCTUnwrap(URL(string: "https://api.openweathermap.org/data/\(version.rawValue)/onecall"))
        let jsonDataURL = try XCTUnwrap(
            Bundle.module.url(
                forResource: "\(version.rawValue.replacingOccurrences(of: ".", with: "-"))-test-response",
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
