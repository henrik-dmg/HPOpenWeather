import CoreLocation
import Foundation

/// A series of forecasts with a fixed time step, from a timeline endpoint of the One Call API 4.0.
///
/// The API sends a limited number of entries in each response.
/// To get the adjacent entries, use ``OpenWeather/nextPage(of:urlSession:)`` and ``OpenWeather/previousPage(of:urlSession:)``.
public struct WeatherTimeline<Entry: Codable & Hashable>: Codable, Hashable {

    // MARK: - Static Methods

    private static func startDate(fromPageURL pageURL: String?) -> Date? {
        guard
            let pageURL,
            let components = URLComponents(string: pageURL),
            let startValue = components.queryItems?.first(where: { $0.name == "start" })?.value,
            let startTimestamp = TimeInterval(startValue)
        else {
            return nil
        }
        return Date(timeIntervalSince1970: startTimestamp)
    }

    // MARK: - Properties

    /// The coordinate of the location of the timeline.
    public let coordinate: CLLocationCoordinate2D
    /// The time zone of the location.
    public let timezone: TimeZone
    /// The forecasts of the timeline, in chronological order.
    public let entries: [Entry]
    /// The start date of the previous page, or `nil` if the API has no earlier data.
    public let previousPageStartDate: Date?
    /// The start date of the next page, or `nil` if the API has no later data.
    public let nextPageStartDate: Date?
    /// The units of the values in the timeline.
    public let units: WeatherUnits
    /// The language of the weather condition descriptions in the timeline.
    public let language: WeatherLanguage

    let resolution: TimelineResolution

    // MARK: - Init/Deinit

    init(envelope: OneCallEnvelope<Entry>, resolution: TimelineResolution, settings: OpenWeather.Settings) {
        self.coordinate = envelope.coordinate
        self.timezone = envelope.timezone
        self.entries = envelope.records
        self.previousPageStartDate = Self.startDate(fromPageURL: envelope.previousPageURL)
        self.nextPageStartDate = Self.startDate(fromPageURL: envelope.nextPageURL)
        self.units = settings.units
        self.language = settings.language
        self.resolution = resolution
    }

}
