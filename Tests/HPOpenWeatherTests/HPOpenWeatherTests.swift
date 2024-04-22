import HPNetwork
import HPNetworkMock
import XCTest

@testable import HPOpenWeather

final class HPOpenWeatherTests: XCTestCase {

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
        try make25WeatherResponse(version: .old)

        let settings = OpenWeather.Settings(apiKey: "debug")
        let request = WeatherRequest(
            coordinate: .init(latitude: 52.5200, longitude: 13.4050),
            excludedFields: nil,
            date: nil,
            settings: settings,
            version: .old
        )
        _ = try await request.response(urlSession: mockedURLSession)
    }

    func testNewApiRequest() async throws {
        try make25WeatherResponse(version: .new)

        let settings = OpenWeather.Settings(apiKey: "debug")
        let request = WeatherRequest(
            coordinate: .init(latitude: 52.5200, longitude: 13.4050),
            excludedFields: nil,
            date: nil,
            settings: settings,
            version: .new
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
            version: .new
        )

        do {
            _ = try await request.response(urlSession: .shared).output
        } catch {
            let apiError = try XCTUnwrap(error as? OpenWeatherAPIError)
            XCTAssertEqual(apiError.code, 401)
        }
    }

    // MARK: - Helpers

    private func make25WeatherResponse(version: WeatherRequest.Version) throws {
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

    //    func testTimeMachineRequestFailing() async throws {
    //        let request = WeatherRequest(coordinate: .init(latitude: 52.5200, longitude: 13.4050), date: Date().addingTimeInterval(-1 * .hour))
    //
    //		await HPAssertThrowsError {
    //			try await OpenWeather.shared.weatherResponse(request)
    //		}
    //    }
    //
    //    func testTimeMachineRequest() async {
    //        let request = WeatherRequest(coordinate: .init(latitude: 52.5200, longitude: 13.4050), date: Date().addingTimeInterval(-7 * .hour))
    //
    //		await HPAssertThrowsNoError {
    //			try await OpenWeather.shared.weatherResponse(request)
    //		}
    //    }
    //
    //    func testPublisher() {
    //        let request = WeatherRequest(coordinate: .init(latitude: 52.5200, longitude: 13.4050))
    //
    //        let expectationFinished = expectation(description: "finished")
    //        let expectationReceive = expectation(description: "receiveValue")
    //        //let expectationFailure = expectation(description: "failure")
    //
    //        let cancellable = request.publisher(apiKey: TestSecret.apiKey).sink(
    //            receiveCompletion: { result in
    //				switch result {
    //				case .failure(let error):
    //					XCTFail(error.localizedDescription)
    //				case .finished:
    //					expectationFinished.fulfill()
    //				}
    //            }, receiveValue: { response in
    //                expectationReceive.fulfill()
    //            }
    //        )
    //
    //        waitForExpectations(timeout: 10) { error in
    //            cancellable.cancel()
    //        }
    //    }

}

extension Encodable {

    func encodeAndDecode<T: Decodable>(type: T.Type) throws -> T {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .secondsSince1970
        let encodedData = try jsonEncoder.encode(self)

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return try jsonDecoder.decode(type.self, from: encodedData)
    }

}
