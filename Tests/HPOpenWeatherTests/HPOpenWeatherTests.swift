import XCTest
import HPNetwork
@testable import HPOpenWeather

final class HPOpenWeatherTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        HPOpenWeather.shared.apiKey = TestSecret.apiKey
    }

    override class func tearDown() {
        super.tearDown()

        HPOpenWeather.shared.apiKey = nil
    }

    func testCurrentRequest() {
        let request = WeatherRequest(coordinate: .init(latitude: 40, longitude: 30))
        let exp = XCTestExpectation(description: "Fetched data")

        HPOpenWeather.shared.requestWeather(request) { result in
            exp.fulfill()
            XCTAssertResult(result)
        }

        wait(for: [exp], timeout: 10)
    }

    func testTimeMachineRequestFailing() {
        let request = TimeMachineRequest(coordinate: .init(latitude: 40, longitude: 30), date: Date().addingTimeInterval(-1 * .hour))
        let exp = XCTestExpectation(description: "Fetched data")

        HPOpenWeather.shared.requestWeather(request) { result in
            exp.fulfill()
            XCTAssertResultError(result)
        }

        wait(for: [exp], timeout: 10)
    }

    func testTimeMachineRequest() {
        let request = TimeMachineRequest(coordinate: .init(latitude: 40, longitude: 30), date: Date().addingTimeInterval(-7 * .hour))
        let exp = XCTestExpectation(description: "Fetched data")

        HPOpenWeather.shared.requestWeather(request) { result in
            exp.fulfill()
            XCTAssertResult(result)
        }

        wait(for: [exp], timeout: 10)
    }


    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testPublisher() {
        let request = WeatherRequest(coordinate: .init(latitude: 40, longitude: 30))

        let expectationFinished = expectation(description: "finished")
        let expectationReceive = expectation(description: "receiveValue")
        //let expectationFailure = expectation(description: "failure")

        let cancellable = request.makePublisher(apiKey: TestSecret.apiKey).sink(
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
