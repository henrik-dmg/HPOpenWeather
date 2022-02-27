import Foundation

/// Type that holds information about daily temperature changes
public struct Temperature: Codable, Equatable, Hashable {

    /// The actually measured temperature
    public let actual: Double
    /// The feels-like temperature
    public let feelsLike: Double

    /// A convertible measurement of the actually measured temperature
    public var actualMeasurement: Measurement<UnitTemperature> {
        actualMeasurement(units: OpenWeather.shared.units)
    }

    /// A convertible measurement of the actually measured temperature
    /// - Parameter units: The units to use when formatting the `actual` property
    public func actualMeasurement(units: WeatherResponse.Units) -> Measurement<UnitTemperature> {
        Measurement(value: actual, unit: units.temperatureUnit)
    }

    /// A convertible measurement of how the actually measured temperature feels like
    public var feelsLikeMeasurement: Measurement<UnitTemperature> {
        feelsLikeMeasurement(units: OpenWeather.shared.units)
    }

    /// A convertible measurement of how the actually measured temperature feels like
    /// - Parameter units: The units to use when formatting the `feelsLike` property
    public func feelsLikeMeasurement(units: WeatherResponse.Units) -> Measurement<UnitTemperature> {
        Measurement(value: feelsLike, unit: units.temperatureUnit)
    }

}
