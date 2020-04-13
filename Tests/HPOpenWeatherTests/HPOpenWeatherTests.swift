import XCTest
import HPNetwork
@testable import HPOpenWeather

final class HPOpenWeatherTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        HPOpenWeather.shared.apiKey = TestSecret.apiKey
    }

    override func tearDown() {
        super.tearDown()

        HPOpenWeather.shared.apiKey = nil
    }

    func testCurrentRequest() {
        let request = CoordinateRequest(coordinate: .init(latitude: 40, longitude: 30), configuration: .default)
        let exp = XCTestExpectation(description: "Fetched data")

        HPOpenWeather.shared.requestWeather(request) { result in
            exp.fulfill()
            XCTAssertResult(result)
        }

        wait(for: [exp], timeout: 10)
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
    if case .failure(let error) = result {
        XCTFail(error.localizedDescription)
    }
}
