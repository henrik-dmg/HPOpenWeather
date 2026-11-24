import CoreLocation
import Foundation
import HPNetwork
import HPNetworkMock
import XCTest

/// Serves the fixture files for the One Call 4.0 endpoints and records the URLs of the requests.
final class OneCallAPIMock {

    // MARK: - Static Properties

    static let berlin = CLLocationCoordinate2D(latitude: 52.52, longitude: 13.405)

    // MARK: - Static Methods

    static func fixtureData(named name: String) throws -> Data {
        let fixtureURL = try XCTUnwrap(Bundle.module.url(forResource: name, withExtension: "json"))
        return try Data(contentsOf: fixtureURL)
    }

    // MARK: - Properties

    let urlSession: URLSession

    private let lock = NSLock()
    private var recordedURLs: [URL] = []

    // MARK: - Computed Properties

    /// The URLs of all requests, in the order that the mock received them.
    var requestedURLs: [URL] {
        lock.lock()
        defer {
            lock.unlock()
        }
        return recordedURLs
    }

    /// The endpoint paths of all requests, relative to `data/4.0/onecall`.
    var requestedPaths: [String] {
        requestedURLs.map { $0.path.replacingOccurrences(of: "/data/4.0/onecall/", with: "") }
    }

    // MARK: - Init/Deinit

    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLSessionMock.self]
        urlSession = URLSession(configuration: configuration)
    }

    // MARK: - Methods

    func mockAllEndpoints() throws {
        try mockEndpoint("current", fixture: "4-0-current")
        try mockEndpoint("timeline/1min", fixture: "4-0-timeline-1min")
        try mockEndpoint("timeline/15min", fixture: "4-0-timeline-15min")
        try mockEndpoint("timeline/1h", fixture: "4-0-timeline-1h")
        try mockEndpoint("timeline/1day", fixture: "4-0-timeline-1day")
        try mockEndpoint("alert/alert-1", fixture: "4-0-alert-1")
        try mockEndpoint("alert/alert-2", fixture: "4-0-alert-2")
    }

    func mockEndpoint(_ path: String, fixture: String, statusCode: Int = 200) throws {
        let url = try XCTUnwrap(URL(string: "https://api.openweathermap.org/data/4.0/onecall/\(path)"))
        let data = try Self.fixtureData(named: fixture)

        URLSessionMock.mockRequest(to: url, ignoresQuery: true) { [weak self] request in
            if let requestURL = request.url {
                self?.record(requestURL)
            }
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: url,
                    statusCode: statusCode,
                    httpVersion: nil,
                    headerFields: ["Content-Type": ContentType.applicationJSON.rawValue]
                )
            )
            return (data, response)
        }
    }

    /// Returns the query items of the last request to the endpoint.
    func queryItems(ofLastRequestTo path: String) throws -> [String: String] {
        let url = try XCTUnwrap(requestedURLs.last { $0.path == "/data/4.0/onecall/\(path)" })
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []
        return Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") })
    }

    // MARK: - Private Methods

    private func record(_ url: URL) {
        lock.lock()
        defer {
            lock.unlock()
        }
        recordedURLs.append(url)
    }

}
