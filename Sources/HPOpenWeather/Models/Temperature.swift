import Foundation

/// Type that holds information about daily temperature changes.
public struct Temperature: Equatable, Hashable {

    /// The actually measured temperature.
    public let actual: Double
    /// The feels-like temperature.
    public let feelsLike: Double

    /// A convertible measurement of the actually measured temperature.
    /// - Parameter units: The units to use when formatting the `actual` property
    /// - Returns: a measurement in the provided unit
    public func actualMeasurement(units: Weather.Units) -> Measurement<UnitTemperature> {
        Measurement(value: actual, unit: units.temperatureUnit)
    }

    /// A convertible measurement of how the actually measured temperature feels like.
    /// - Parameter units: The units to use when formatting the `feelsLike` property
    /// - Returns: a measurement in the provided unit
    public func feelsLikeMeasurement(units: Weather.Units) -> Measurement<UnitTemperature> {
        Measurement(value: feelsLike, unit: units.temperatureUnit)
    }

}
