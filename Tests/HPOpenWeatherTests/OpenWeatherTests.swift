import HPNetwork
import HPNetworkMock
import XCTest

@testable import HPOpenWeather

final class OpenWeatherTests: XCTestCase {

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

    // MARK: - Current Weather

    func testCurrentWeather() async throws {
        let client = OpenWeather(apiKey: "debug")
        let currentWeather = try await client.currentWeather(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)

        XCTAssertEqual(currentWeather.timestamp, Date(timeIntervalSince1970: 1_764_000_000))
        XCTAssertEqual(currentWeather.temperature, Temperature(actual: 4.2, feelsLike: 1.3))
        XCTAssertEqual(currentWeather.rain?.lastHour, 0.42)
        XCTAssertNil(currentWeather.snow)
        XCTAssertEqual(currentWeather.wind, Wind(speed: 3.6, gust: 7.1, degrees: 240))
        XCTAssertEqual(currentWeather.sun.sunrise, Date(timeIntervalSince1970: 1_763_967_600))
        XCTAssertEqual(currentWeather.currentCondition.icon, .rainNight)
        XCTAssertEqual(currentWeather.alertIDs, ["alert-1"])

        let queryItems = try apiMock.queryItems(ofLastRequestTo: "current")
        XCTAssertEqual(
            queryItems,
            ["lat": "52.52000", "lon": "13.40500", "appid": "debug", "units": "metric", "lang": "en"]
        )
    }

    func testMissingAPIKey() async throws {
        let client = OpenWeather()

        do {
            _ = try await client.currentWeather(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)
            XCTFail("The request must fail without an API key")
        } catch {
            XCTAssertEqual(error as? OpenWeatherError, .invalidAPIKey)
        }
        XCTAssertTrue(apiMock.requestedURLs.isEmpty)
    }

    func testAPIErrorResponse() async throws {
        URLSessionMock.unregisterAllMockedRequests()
        try apiMock.mockEndpoint("timeline/1h", fixture: "4-0-error", statusCode: 400)
        let client = OpenWeather(apiKey: "debug")

        do {
            _ = try await client.hourlyForecast(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)
            XCTFail("The request must fail with an API error")
        } catch {
            let apiError = try XCTUnwrap(error as? OpenWeatherAPIError)
            XCTAssertEqual(apiError.code, 400)
            XCTAssertEqual(apiError.parameters, ["start"])
        }
    }

    func testInvalidAPIKey() async throws {
        let client = OpenWeather(apiKey: "debug")

        do {
            _ = try await client.currentWeather(for: OneCallAPIMock.berlin, urlSession: .shared)
            XCTFail("The request must fail with an invalid API key")
        } catch {
            let apiError = try XCTUnwrap(error as? OpenWeatherAPIError)
            XCTAssertEqual(apiError.code, 401)
        }
    }

    // MARK: - Timelines

    func testMinutelyForecast() async throws {
        let client = OpenWeather(apiKey: "debug")
        let timeline = try await client.minutelyForecast(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)

        XCTAssertEqual(timeline.coordinate, OneCallAPIMock.berlin)
        XCTAssertEqual(timeline.timezone.identifier, "Europe/Berlin")
        XCTAssertEqual(timeline.entries.map(\.precipitation), [0, 0.12, 0.25])
        XCTAssertEqual(timeline.entries.map(\.alertIDs), [[], ["alert-1"], ["alert-1"]])
        XCTAssertNil(timeline.previousPageStartDate)
        XCTAssertNil(timeline.nextPageStartDate)

        let nextPage = try await client.nextPage(of: timeline, urlSession: apiMock.urlSession)
        let previousPage = try await client.previousPage(of: timeline, urlSession: apiMock.urlSession)
        XCTAssertNil(nextPage)
        XCTAssertNil(previousPage)
        XCTAssertEqual(apiMock.requestedPaths, ["timeline/1min"])
    }

    func testQuarterHourlyForecast() async throws {
        let client = OpenWeather(apiKey: "debug")
        let timeline = try await client.quarterHourlyForecast(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)

        XCTAssertEqual(timeline.entries.count, 2)
        XCTAssertEqual(timeline.entries.map(\.precipitationProbability), [0.4, 0.6])
        XCTAssertEqual(timeline.entries[1].snow?.lastHour, 0.3)
        XCTAssertEqual(timeline.entries[1].condition.icon, .snowNight)
        XCTAssertNil(timeline.previousPageStartDate)
        XCTAssertEqual(timeline.nextPageStartDate, Date(timeIntervalSince1970: 1_764_001_800))
    }

    func testHourlyForecastWithStartDate() async throws {
        let client = OpenWeather(apiKey: "debug")
        let timeline = try await client.hourlyForecast(
            for: OneCallAPIMock.berlin,
            startDate: Date(timeIntervalSince1970: 1_764_000_000),
            urlSession: apiMock.urlSession
        )

        XCTAssertEqual(timeline.entries.count, 2)
        XCTAssertEqual(timeline.entries[1].rain?.lastHour, 0.5)
        XCTAssertEqual(timeline.entries[1].wind.gust, 11.3)
        XCTAssertEqual(timeline.previousPageStartDate, Date(timeIntervalSince1970: 1_763_992_800))
        XCTAssertEqual(timeline.nextPageStartDate, Date(timeIntervalSince1970: 1_764_007_200))

        let queryItems = try apiMock.queryItems(ofLastRequestTo: "timeline/1h")
        XCTAssertEqual(queryItems["start"], "1764000000")
    }

    func testDailyForecast() async throws {
        let client = OpenWeather(apiKey: "debug")
        let timeline = try await client.dailyForecast(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)

        XCTAssertEqual(timeline.entries.count, 2)
        let firstDay = try XCTUnwrap(timeline.entries.first)
        XCTAssertEqual(firstDay.temperature.min, 1.2)
        XCTAssertEqual(firstDay.temperature.max, 6.3)
        XCTAssertNil(firstDay.feelsLikeTemperature.min)
        XCTAssertEqual(firstDay.feelsLikeTemperature.morning, -1.6)
        XCTAssertEqual(firstDay.totalRain, 1.2)
        XCTAssertNil(firstDay.totalSnow)
        XCTAssertEqual(firstDay.precipitationProbability, 0.8)
        // The fixture sends 0 for the moonrise, as the API does for an event that does not occur.
        XCTAssertEqual(firstDay.moon, Moon(moonset: Date(timeIntervalSince1970: 1_763_986_000), moonrise: nil, phase: 0.13))
        XCTAssertEqual(firstDay.alertIDs, [])
        XCTAssertEqual(timeline.entries[1].totalSnow, 0.7)
        XCTAssertEqual(timeline.entries[1].alertIDs, ["alert-2"])
    }

    func testNextPageUsesSettingsOfTimeline() async throws {
        let client = OpenWeather(settings: OpenWeather.Settings(apiKey: "debug", language: .german, units: .imperial))
        let timeline = try await client.dailyForecast(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)
        client.language = .english
        client.units = .metric

        let nextPage = try await client.nextPage(of: timeline, urlSession: apiMock.urlSession)
        XCTAssertEqual(nextPage?.units, .imperial)
        XCTAssertEqual(nextPage?.language, .german)

        let queryItems = try apiMock.queryItems(ofLastRequestTo: "timeline/1day")
        XCTAssertEqual(queryItems["start"], "1764878400")
        XCTAssertEqual(queryItems["units"], "imperial")
        XCTAssertEqual(queryItems["lang"], "de")
        XCTAssertEqual(queryItems["lat"], "52.52000")
    }

    func testPreviousPage() async throws {
        let client = OpenWeather(apiKey: "debug")
        let timeline = try await client.hourlyForecast(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)

        let previousPage = try await client.previousPage(of: timeline, urlSession: apiMock.urlSession)
        XCTAssertNotNil(previousPage)

        let queryItems = try apiMock.queryItems(ofLastRequestTo: "timeline/1h")
        XCTAssertEqual(queryItems["start"], "1763992800")
    }

    // MARK: - Alerts

    func testWeatherAlert() async throws {
        let client = OpenWeather(apiKey: "debug")
        let alert = try await client.weatherAlert(withID: "alert-1", urlSession: apiMock.urlSession)

        XCTAssertEqual(alert.id, "alert-1")
        XCTAssertEqual(alert.eventName, "Frost")
        XCTAssertEqual(alert.startDate, Date(timeIntervalSince1970: 1_764_000_000))
        XCTAssertEqual(alert.endDate, Date(timeIntervalSince1970: 1_764_043_200))
        XCTAssertEqual(alert.descriptions.map(\.languageCode), ["de-DE", "en-GB"])
        XCTAssertEqual(alert.tags, ["Extreme low temperature"])

        let queryItems = try apiMock.queryItems(ofLastRequestTo: "alert/alert-1")
        XCTAssertEqual(queryItems, ["appid": "debug"])
    }

    // MARK: - Combined Weather

    func testWeather() async throws {
        let client = OpenWeather(apiKey: "debug")
        let weather = try await client.weather(for: OneCallAPIMock.berlin, urlSession: apiMock.urlSession)

        XCTAssertEqual(weather.timezone.identifier, "Europe/Berlin")
        XCTAssertEqual(weather.currentWeather?.timestamp, Date(timeIntervalSince1970: 1_764_000_000))
        XCTAssertEqual(weather.minutelyForecasts?.count, 3)
        XCTAssertEqual(weather.quarterHourlyForecasts?.count, 2)
        XCTAssertEqual(weather.hourlyForecasts?.count, 2)
        XCTAssertEqual(weather.dailyForecasts?.count, 2)
        XCTAssertEqual(weather.alerts?.map(\.id), ["alert-1", "alert-2"])
        XCTAssertEqual(weather.units, .metric)
        XCTAssertEqual(weather.language, .english)

        XCTAssertEqual(
            Set(apiMock.requestedPaths),
            ["current", "timeline/1min", "timeline/15min", "timeline/1h", "timeline/1day", "alert/alert-1", "alert/alert-2"]
        )
        XCTAssertEqual(apiMock.requestedPaths.count, 7)
    }

    func testWeatherWithExcludedFields() async throws {
        let client = OpenWeather(apiKey: "debug")
        let weather = try await client.weather(
            for: OneCallAPIMock.berlin,
            excludedFields: [.minutely, .quarterHourly, .alerts],
            urlSession: apiMock.urlSession
        )

        XCTAssertNotNil(weather.currentWeather)
        XCTAssertNil(weather.minutelyForecasts)
        XCTAssertNil(weather.quarterHourlyForecasts)
        XCTAssertNotNil(weather.hourlyForecasts)
        XCTAssertNotNil(weather.dailyForecasts)
        XCTAssertNil(weather.alerts)
        XCTAssertEqual(Set(apiMock.requestedPaths), ["current", "timeline/1h", "timeline/1day"])
    }

    func testWeatherWithAllForecastsExcluded() async throws {
        let client = OpenWeather(apiKey: "debug")

        do {
            _ = try await client.weather(
                for: OneCallAPIMock.berlin,
                excludedFields: [.current, .minutely, .quarterHourly, .hourly, .daily],
                urlSession: apiMock.urlSession
            )
            XCTFail("The request must fail when all forecasts are excluded")
        } catch {
            XCTAssertEqual(error as? OpenWeatherError, .allForecastsExcluded)
        }
        XCTAssertTrue(apiMock.requestedURLs.isEmpty)
    }

}
