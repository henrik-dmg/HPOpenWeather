import CoreLocation
import Foundation

/// A type to request current weather conditions and forecasts from the One Call API 4.0.
public final class OpenWeather {

    // MARK: - Nested Types

    /// Type that can be used to configure all settings at once.
    public struct Settings: Sendable {
        /// The API key to use for weather requests.
        let apiKey: String
        /// The language that will be used in weather responses.
        let language: WeatherLanguage
        /// The units that will be used in weather responses.
        let units: WeatherUnits

        /// Initialises a new settings instance.
        /// - Parameters:
        ///   - apiKey: The API key to use for weather requests
        ///   - language: The language that will be used in weather responses
        ///   - units: The units that will be used in weather responses
        public init(apiKey: String, language: WeatherLanguage = .english, units: WeatherUnits = .metric) {
            self.language = language
            self.units = units
            self.apiKey = apiKey
        }
    }

    // MARK: - Properties

    /// The OpenWeather API key to authorize requests.
    public var apiKey: String?
    /// The language that should be used in API responses.
    public var language: WeatherLanguage = .english
    /// The units that should be used to format the API responses.
    public var units: WeatherUnits = .metric

    // MARK: - Init

    /// Initialised a new instance of `OpenWeather` and applies the specified API key.
    /// - Parameter apiKey: the API key to authenticate with the OpenWeatherMap API
    public init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }

    /// Initialised a new instance of `OpenWeather` and applies the specified settings.
    /// - Parameter settings: the settings to apply, including API key, language and units
    public init(settings: Settings) {
        self.apiKey = settings.apiKey
        self.language = settings.language
        self.units = settings.units
    }

    // MARK: - Methods

    /// Requests the current weather, the forecasts and the weather alerts for the specified location.
    ///
    /// This method calls one One Call 4.0 endpoint for each forecast field that you do not exclude. The calls run in parallel.
    /// Then it requests the details of each weather alert that the responses refer to, unless you exclude ``ExcludableField/alerts``.
    /// Each call counts against your API quota.
    /// - Parameters:
    ///   - coordinate: The coordinate for which the weather will be requested
    ///   - excludedFields: The fields that will not be requested
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: A weather response object
    /// - Throws: If no API key was provided, all forecast fields were excluded, the networking failed or a response failed to decode
    public func weather(
        for coordinate: CLLocationCoordinate2D,
        excludedFields: [ExcludableField]? = nil,
        urlSession: URLSession = .shared
    ) async throws -> Weather {
        let settings = try makeSettings()
        let excludedFields = Set(excludedFields ?? [])

        async let currentResponse: OneCallEnvelope<CurrentWeather>? = Self.envelope(
            for: .current(coordinate: coordinate),
            isIncluded: !excludedFields.contains(.current),
            settings: settings,
            urlSession: urlSession
        )
        async let minutelyResponse: OneCallEnvelope<MinutelyForecast>? = Self.envelope(
            for: .timeline(resolution: .minute, coordinate: coordinate, startDate: nil),
            isIncluded: !excludedFields.contains(.minutely),
            settings: settings,
            urlSession: urlSession
        )
        async let quarterHourlyResponse: OneCallEnvelope<QuarterHourlyForecast>? = Self.envelope(
            for: .timeline(resolution: .quarterHour, coordinate: coordinate, startDate: nil),
            isIncluded: !excludedFields.contains(.quarterHourly),
            settings: settings,
            urlSession: urlSession
        )
        async let hourlyResponse: OneCallEnvelope<HourlyForecast>? = Self.envelope(
            for: .timeline(resolution: .hour, coordinate: coordinate, startDate: nil),
            isIncluded: !excludedFields.contains(.hourly),
            settings: settings,
            urlSession: urlSession
        )
        async let dailyResponse: OneCallEnvelope<DailyForecast>? = Self.envelope(
            for: .timeline(resolution: .day, coordinate: coordinate, startDate: nil),
            isIncluded: !excludedFields.contains(.daily),
            settings: settings,
            urlSession: urlSession
        )

        let current = try await currentResponse
        let minutely = try await minutelyResponse
        let quarterHourly = try await quarterHourlyResponse
        let hourly = try await hourlyResponse
        let daily = try await dailyResponse

        let timezones = [current?.timezone, minutely?.timezone, quarterHourly?.timezone, hourly?.timezone, daily?.timezone]
        guard let timezone = timezones.compactMap({ $0 }).first else {
            throw OpenWeatherError.allForecastsExcluded
        }

        let alerts: [WeatherAlert]?
        if excludedFields.contains(.alerts) {
            alerts = nil
        } else {
            let alertIDs = [
                current?.records.flatMap(\.alertIDs),
                minutely?.records.flatMap(\.alertIDs),
                quarterHourly?.records.flatMap(\.alertIDs),
                hourly?.records.flatMap(\.alertIDs),
                daily?.records.flatMap(\.alertIDs),
            ]
            alerts = try await Self.alerts(withIDs: alertIDs.flatMap { $0 ?? [] }, settings: settings, urlSession: urlSession)
        }

        return Weather(
            timezone: timezone,
            currentWeather: current?.records.first,
            minutelyForecasts: minutely?.records,
            quarterHourlyForecasts: quarterHourly?.records,
            hourlyForecasts: hourly?.records,
            dailyForecasts: daily?.records,
            alerts: alerts,
            language: settings.language,
            units: settings.units
        )
    }

    /// Requests the current weather for the specified location.
    /// - Parameters:
    ///   - coordinate: The coordinate for which the weather will be requested
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: The current weather
    /// - Throws: If no API key was provided, the networking failed or the response failed to decode
    public func currentWeather(
        for coordinate: CLLocationCoordinate2D,
        urlSession: URLSession = .shared
    ) async throws -> CurrentWeather {
        let response: OneCallEnvelope<CurrentWeather> = try await Self.envelope(
            for: .current(coordinate: coordinate),
            settings: makeSettings(),
            urlSession: urlSession
        )
        guard let currentWeather = response.records.first else {
            throw OpenWeatherError.noCurrentWeatherReturned
        }
        return currentWeather
    }

    /// Requests the precipitation forecast for each minute of the next hour.
    /// - Parameters:
    ///   - coordinate: The coordinate for which the forecast will be requested
    ///   - startDate: The date of the first entry. If no date is provided, the timeline starts at the current time
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: A timeline with up to 60 entries
    /// - Throws: If no API key was provided, the networking failed or the response failed to decode
    public func minutelyForecast(
        for coordinate: CLLocationCoordinate2D,
        startDate: Date? = nil,
        urlSession: URLSession = .shared
    ) async throws -> WeatherTimeline<MinutelyForecast> {
        try await Self.timeline(
            resolution: .minute,
            coordinate: coordinate,
            startDate: startDate,
            settings: makeSettings(),
            urlSession: urlSession
        )
    }

    /// Requests the forecast for each 15 minutes of the next 48 hours.
    /// - Parameters:
    ///   - coordinate: The coordinate for which the forecast will be requested
    ///   - startDate: The date of the first entry. If no date is provided, the timeline starts at the current time
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: A timeline with up to 50 entries
    /// - Throws: If no API key was provided, the networking failed or the response failed to decode
    public func quarterHourlyForecast(
        for coordinate: CLLocationCoordinate2D,
        startDate: Date? = nil,
        urlSession: URLSession = .shared
    ) async throws -> WeatherTimeline<QuarterHourlyForecast> {
        try await Self.timeline(
            resolution: .quarterHour,
            coordinate: coordinate,
            startDate: startDate,
            settings: makeSettings(),
            urlSession: urlSession
        )
    }

    /// Requests the weather for each hour.
    ///
    /// The API has historical data and a forecast for the next 48 hours.
    /// - Parameters:
    ///   - coordinate: The coordinate for which the forecast will be requested
    ///   - startDate: The date of the first entry. If no date is provided, the timeline starts at the current time
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: A timeline with up to 20 entries
    /// - Throws: If no API key was provided, the networking failed or the response failed to decode
    public func hourlyForecast(
        for coordinate: CLLocationCoordinate2D,
        startDate: Date? = nil,
        urlSession: URLSession = .shared
    ) async throws -> WeatherTimeline<HourlyForecast> {
        try await Self.timeline(
            resolution: .hour,
            coordinate: coordinate,
            startDate: startDate,
            settings: makeSettings(),
            urlSession: urlSession
        )
    }

    /// Requests the weather for each day.
    ///
    /// The API has historical data and a forecast for up to 1.5 years.
    /// - Parameters:
    ///   - coordinate: The coordinate for which the forecast will be requested
    ///   - startDate: The date of the first entry. If no date is provided, the timeline starts at the current time
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: A timeline with up to 10 entries
    /// - Throws: If no API key was provided, the networking failed or the response failed to decode
    public func dailyForecast(
        for coordinate: CLLocationCoordinate2D,
        startDate: Date? = nil,
        urlSession: URLSession = .shared
    ) async throws -> WeatherTimeline<DailyForecast> {
        try await Self.timeline(
            resolution: .day,
            coordinate: coordinate,
            startDate: startDate,
            settings: makeSettings(),
            urlSession: urlSession
        )
    }

    /// Requests the details of a weather alert.
    /// - Parameters:
    ///   - id: The ID of the alert, from the `alertIDs` property of a forecast
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: The weather alert
    /// - Throws: If no API key was provided, the networking failed or the response failed to decode
    public func weatherAlert(withID id: String, urlSession: URLSession = .shared) async throws -> WeatherAlert {
        try await Self.alert(withID: id, settings: makeSettings(), urlSession: urlSession)
    }

    /// Requests the entries that follow the last entry of a timeline.
    ///
    /// The request uses the units and the language of the timeline.
    /// - Parameters:
    ///   - timeline: The timeline to continue
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: The next page of the timeline, or `nil` if the API has no later data
    /// - Throws: If no API key was provided, the networking failed or the response failed to decode
    public func nextPage<Entry>(
        of timeline: WeatherTimeline<Entry>,
        urlSession: URLSession = .shared
    ) async throws -> WeatherTimeline<Entry>? {
        guard let startDate = timeline.nextPageStartDate else {
            return nil
        }
        return try await page(of: timeline, startDate: startDate, urlSession: urlSession)
    }

    /// Requests the entries that come before the first entry of a timeline.
    ///
    /// The request uses the units and the language of the timeline.
    /// - Parameters:
    ///   - timeline: The timeline to continue
    ///   - urlSession: The `URLSession` that will be used schedule requests
    /// - Returns: The previous page of the timeline, or `nil` if the API has no earlier data
    /// - Throws: If no API key was provided, the networking failed or the response failed to decode
    public func previousPage<Entry>(
        of timeline: WeatherTimeline<Entry>,
        urlSession: URLSession = .shared
    ) async throws -> WeatherTimeline<Entry>? {
        guard let startDate = timeline.previousPageStartDate else {
            return nil
        }
        return try await page(of: timeline, startDate: startDate, urlSession: urlSession)
    }

    /// Requests the current weather, the forecasts and the weather alerts for the specified location.
    ///
    /// See ``weather(for:excludedFields:urlSession:)`` for the API calls that this method causes.
    /// - Parameters:
    ///   - coordinate: The coordinate for which the weather will be requested
    ///   - excludedFields: The fields that will not be requested
    ///   - urlSession: The `URLSession` that will be used schedule requests
    ///   - completion: A completion that will be called with the result of the network request
    /// - Returns: A network task that can be used to cancel the request
    @discardableResult
    public func requestWeather(
        for coordinate: CLLocationCoordinate2D,
        excludedFields: [ExcludableField]? = nil,
        urlSession: URLSession = .shared,
        completion: @escaping @Sendable (Result<Weather, Error>) -> Void
    ) -> Task<Void, Error> {
        Task {
            do {
                let response = try await weather(
                    for: coordinate,
                    excludedFields: excludedFields,
                    urlSession: urlSession
                )
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private Methods

    private func makeSettings(language: WeatherLanguage? = nil, units: WeatherUnits? = nil) throws -> Settings {
        guard let apiKey, !apiKey.isEmpty else {
            throw OpenWeatherError.invalidAPIKey
        }
        return Settings(apiKey: apiKey, language: language ?? self.language, units: units ?? self.units)
    }

    private func page<Entry>(
        of timeline: WeatherTimeline<Entry>,
        startDate: Date,
        urlSession: URLSession
    ) async throws -> WeatherTimeline<Entry> {
        try await Self.timeline(
            resolution: timeline.resolution,
            coordinate: timeline.coordinate,
            startDate: startDate,
            settings: makeSettings(language: timeline.language, units: timeline.units),
            urlSession: urlSession
        )
    }

}

// MARK: - Requests Extension

extension OpenWeather {

    private static func envelope<Record: Decodable>(
        for endpoint: OneCallEndpoint,
        settings: Settings,
        urlSession: URLSession
    ) async throws -> OneCallEnvelope<Record> {
        try await OneCallRequest<OneCallEnvelope<Record>>(endpoint: endpoint, settings: settings).response(urlSession: urlSession).output
    }

    /// Requests the envelope only if the field is included.
    ///
    /// Returns `nil` and sends no request if the field is excluded.
    private static func envelope<Record: Decodable>(
        for endpoint: OneCallEndpoint,
        isIncluded: Bool,
        settings: Settings,
        urlSession: URLSession
    ) async throws -> OneCallEnvelope<Record>? {
        guard isIncluded else {
            return nil
        }
        return try await envelope(for: endpoint, settings: settings, urlSession: urlSession)
    }

    private static func timeline<Entry>(
        resolution: TimelineResolution,
        coordinate: CLLocationCoordinate2D,
        startDate: Date?,
        settings: Settings,
        urlSession: URLSession
    ) async throws -> WeatherTimeline<Entry> {
        let response: OneCallEnvelope<Entry> = try await envelope(
            for: .timeline(resolution: resolution, coordinate: coordinate, startDate: startDate),
            settings: settings,
            urlSession: urlSession
        )
        return WeatherTimeline(envelope: response, resolution: resolution, settings: settings)
    }

    private static func alert(withID id: String, settings: Settings, urlSession: URLSession) async throws -> WeatherAlert {
        try await OneCallRequest<WeatherAlert>(endpoint: .alert(id: id), settings: settings).response(urlSession: urlSession).output
    }

    /// Requests the alerts in parallel.
    ///
    /// Removes duplicate IDs and keeps the order of the first occurrence of each ID.
    private static func alerts(withIDs ids: [String], settings: Settings, urlSession: URLSession) async throws -> [WeatherAlert] {
        var knownIDs = Set<String>()
        let uniqueIDs = ids.filter { knownIDs.insert($0).inserted }

        return try await withThrowingTaskGroup(of: (Int, WeatherAlert).self) { group in
            for (index, id) in uniqueIDs.enumerated() {
                group.addTask {
                    let alert = try await Self.alert(withID: id, settings: settings, urlSession: urlSession)
                    return (index, alert)
                }
            }

            var indexedAlerts: [(Int, WeatherAlert)] = []
            for try await indexedAlert in group {
                indexedAlerts.append(indexedAlert)
            }
            return indexedAlerts.sorted { $0.0 < $1.0 }.map(\.1)
        }
    }

}
