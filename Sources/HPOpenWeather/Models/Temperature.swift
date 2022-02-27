import Foundation

/// Type that holds information about daily temperature changes
public struct Temperature: Codable, Equatable, Hashable {

	/// The actually measured temperature
    public let actual: Double
	/// The feels-like temperature
    public let feelsLike: Double

	public var actualMeasurement: Measurement<UnitTemperature> {
		actualMeasurement(units: OpenWeather.shared.units)
	}

	public func actualMeasurement(units: WeatherResponse.Units) -> Measurement<UnitTemperature> {
		Measurement(value: actual, unit: units.temperatureUnit)
	}

	public var feelsLikeMeasurement: Measurement<UnitTemperature> {
		feelsLikeMeasurement(units: OpenWeather.shared.units)
	}

	public func feelsLikeMeasurement(units: WeatherResponse.Units) -> Measurement<UnitTemperature> {
		Measurement(value: feelsLike, unit: units.temperatureUnit)
	}

}
