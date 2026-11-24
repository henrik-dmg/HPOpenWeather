import Foundation

/// A part of ``Weather`` that ``OpenWeather/weather(for:excludedFields:urlSession:)`` can skip.
///
/// Each forecast field that you do not exclude causes one call to the One Call API 4.0.
/// The ``alerts`` field causes one call for each weather alert.
public enum ExcludableField: String, Codable {

    /// The current weather.
    case current
    /// The forecasts for each minute of the next hour.
    case minutely
    /// The forecasts for each 15 minutes.
    case quarterHourly = "quarter_hourly"
    /// The forecasts for each hour.
    case hourly
    /// The forecasts for each day.
    case daily
    /// The details of the weather alerts that the other fields refer to.
    case alerts

}
