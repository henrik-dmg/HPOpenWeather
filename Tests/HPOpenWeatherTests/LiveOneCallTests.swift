import CoreLocation
import XCTest

@testable import HPOpenWeather

/// Calls the real One Call API 4.0.
///
/// The tests skip when the `API_KEY` environment variable is not set.
/// The key must have a subscription to the One Call by Call plan. One run uses about 20 API calls.
final class LiveOneCallTests: XCTestCase {

    // MARK: - Static Properties

    /// A location with frequent weather alerts.
    private static let seattle = CLLocationCoordinate2D(latitude: 47.61, longitude: -122.33)
    /// A location with the polar night from November to January.
    private static let longyearbyen = CLLocationCoordinate2D(latitude: 78.22, longitude: 15.65)

    // MARK: - Tests

    func testCurrentWeather() async throws {
        let client = try makeClient()
        let currentWeather = try await client.currentWeather(for: Self.seattle)

        XCTAssertLessThan(abs(currentWeather.timestamp.timeIntervalSinceNow), 60 * 60)
        XCTAssertNotNil(currentWeather.humidity)
    }

    func testTimelines() async throws {
        let client = try makeClient()

        let minutely = try await client.minutelyForecast(for: Self.seattle)
        XCTAssertFalse(minutely.entries.isEmpty)
        XCTAssertLessThanOrEqual(minutely.entries.count, 60)
        assertChronological(minutely.entries.map(\.timestamp), step: 60)

        let quarterHourly = try await client.quarterHourlyForecast(for: Self.seattle)
        XCTAssertFalse(quarterHourly.entries.isEmpty)
        XCTAssertLessThanOrEqual(quarterHourly.entries.count, 50)
        assertChronological(quarterHourly.entries.map(\.timestamp), step: 15 * 60)

        let hourly = try await client.hourlyForecast(for: Self.seattle)
        XCTAssertFalse(hourly.entries.isEmpty)
        XCTAssertLessThanOrEqual(hourly.entries.count, 20)
        assertChronological(hourly.entries.map(\.timestamp), step: 60 * 60)

        let daily = try await client.dailyForecast(for: Self.seattle)
        XCTAssertFalse(daily.entries.isEmpty)
        XCTAssertLessThanOrEqual(daily.entries.count, 10)
        assertChronological(daily.entries.map(\.timestamp), step: 24 * 60 * 60)
        XCTAssertEqual(daily.units, .metric)
        XCTAssertEqual(daily.language, .english)
    }

    func testPaging() async throws {
        let client = try makeClient()
        let hourly = try await client.hourlyForecast(for: Self.seattle)
        let lastEntry = try XCTUnwrap(hourly.entries.last)

        let nextPage = try await client.nextPage(of: hourly)
        let firstEntryOfNextPage = try XCTUnwrap(nextPage?.entries.first)
        XCTAssertEqual(firstEntryOfNextPage.timestamp, lastEntry.timestamp.addingTimeInterval(60 * 60))

        let previousPage = try await client.previousPage(of: hourly)
        let lastEntryOfPreviousPage = try XCTUnwrap(previousPage?.entries.last)
        let firstEntry = try XCTUnwrap(hourly.entries.first)
        XCTAssertEqual(lastEntryOfPreviousPage.timestamp, firstEntry.timestamp.addingTimeInterval(-60 * 60))
    }

    func testHistoricalHourlyForecast() async throws {
        let client = try makeClient()
        let startDate = Date(timeIntervalSince1970: 1_735_689_600)
        let timeline = try await client.hourlyForecast(for: Self.seattle, startDate: startDate)

        XCTAssertEqual(timeline.entries.first?.timestamp, startDate)
    }

    func testPolarNightDailyForecast() async throws {
        let client = try makeClient()
        let timeline = try await client.dailyForecast(for: Self.longyearbyen)

        XCTAssertFalse(timeline.entries.isEmpty)
        for entry in timeline.entries {
            // The API sends 0 or no value when the sun does not rise. A decoded date must never be the Unix epoch.
            XCTAssertNotEqual(entry.sun.sunrise?.timeIntervalSince1970, 0)
            XCTAssertNotEqual(entry.moon.moonrise?.timeIntervalSince1970, 0)
        }
    }

    func testWeatherWithAlerts() async throws {
        let client = try makeClient()
        let weather = try await client.weather(for: Self.seattle)

        XCTAssertNotNil(weather.currentWeather)
        XCTAssertNotNil(weather.minutelyForecasts)
        XCTAssertNotNil(weather.quarterHourlyForecasts)
        XCTAssertNotNil(weather.hourlyForecasts)
        XCTAssertNotNil(weather.dailyForecasts)

        let alerts = try XCTUnwrap(weather.alerts)
        var referencedAlertIDs = Set<String>()
        referencedAlertIDs.formUnion(weather.currentWeather?.alertIDs ?? [])
        referencedAlertIDs.formUnion(weather.minutelyForecasts?.flatMap(\.alertIDs) ?? [])
        referencedAlertIDs.formUnion(weather.quarterHourlyForecasts?.flatMap(\.alertIDs) ?? [])
        referencedAlertIDs.formUnion(weather.hourlyForecasts?.flatMap(\.alertIDs) ?? [])
        referencedAlertIDs.formUnion(weather.dailyForecasts?.flatMap(\.alertIDs) ?? [])
        XCTAssertEqual(Set(alerts.map(\.id)).count, alerts.count)
        XCTAssertEqual(Set(alerts.map(\.id)), referencedAlertIDs)
        for alert in alerts {
            XCTAssertFalse(alert.descriptions.isEmpty)
            XCTAssertLessThanOrEqual(alert.startDate, alert.endDate)
        }
    }

    // MARK: - Private Methods

    private func makeClient() throws -> OpenWeather {
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"], !apiKey.isEmpty else {
            throw XCTSkip("Set the API_KEY environment variable to run the live One Call 4.0 tests.")
        }
        return OpenWeather(settings: OpenWeather.Settings(apiKey: apiKey, language: .english, units: .metric))
    }

    private func assertChronological(_ timestamps: [Date], step: TimeInterval, file: StaticString = #filePath, line: UInt = #line) {
        for (earlier, later) in zip(timestamps, timestamps.dropFirst()) {
            XCTAssertEqual(later.timeIntervalSince(earlier), step, file: file, line: line)
        }
    }

}
