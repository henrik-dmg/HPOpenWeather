import XCTest
import HPNetwork
@testable import HPOpenWeather

final class HPOpenWeatherTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        HPOpenWeather.shared.apiKey = "a8079f7388cb52b6ec144a2727c7c08b"
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
            switch result {
            case .success(let response):
                print(response.hourlyForecasts.first)
                print(response.current.condition)
            case .failure(let error as NSError):
                print(error)
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [exp], timeout: 10)
    }

}
