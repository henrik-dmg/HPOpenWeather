import XCTest
import HPNetwork
@testable import HPOpenWeather

final class HPOpenWeatherTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        OpenWeather.shared.apiKey = TestSecret.apiKey
    }

    override class func tearDown() {
        super.tearDown()
        OpenWeather.shared.apiKey = nil
    }

    func testCurrentRequest() async throws {
		do {
			_ = try await OpenWeather.shared.weatherResponse(coordinate: .init(latitude: 52.5200, longitude: 13.4050))
		} catch let error as NSError {
			print(error)
			throw error
		}
    }

    func testTimeMachineRequestFailing() async throws {
        let request = WeatherRequest(coordinate: .init(latitude: 52.5200, longitude: 13.4050), date: Date().addingTimeInterval(-1 * .hour))

		await HPAssertThrowsError {
			try await OpenWeather.shared.weatherResponse(request)
		}
    }

    func testTimeMachineRequest() async {
        let request = WeatherRequest(coordinate: .init(latitude: 52.5200, longitude: 13.4050), date: Date().addingTimeInterval(-7 * .hour))

		await HPAssertThrowsNoError {
			try await OpenWeather.shared.weatherResponse(request)
		}
    }

    func testPublisher() {
        let request = WeatherRequest(coordinate: .init(latitude: 52.5200, longitude: 13.4050))

        let expectationFinished = expectation(description: "finished")
        let expectationReceive = expectation(description: "receiveValue")
        //let expectationFailure = expectation(description: "failure")

        let cancellable = request.publisher(apiKey: TestSecret.apiKey).sink(
            receiveCompletion: { result in
				switch result {
				case .failure(let error):
					XCTFail(error.localizedDescription)
				case .finished:
					expectationFinished.fulfill()
				}
            }, receiveValue: { response in
                expectationReceive.fulfill()
            }
        )

        waitForExpectations(timeout: 10) { error in
            cancellable.cancel()
        }
    }

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

func HPAssertThrowsError<T>(_ work: () async throws -> T) async {
	do {
		_ = try await work()
		XCTFail("Block should throw")
	} catch {
		return
	}
}

func HPAssertThrowsNoError<T>(_ work: () async throws -> T) async {
	do {
		_ = try await work()
	} catch let error {
		XCTFail(error.localizedDescription)
	}
}

/// Asserts that the result is not a failure
func XCTAssertResult<T, E: Error>(_ result: Result<T, E>) {
    if case .failure(let error as NSError) = result {
		XCTFail(error.localizedDescription)
    }
}

/// Asserts that the result is not a failure
func XCTAssertResultError<T, E: Error>(_ result: Result<T, E>) {
    if case .success(_) = result {
        XCTFail("Result was not an error")
    }
}
