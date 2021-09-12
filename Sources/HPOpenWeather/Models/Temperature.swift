import Foundation

/// Type that holds information about daily temperature changes
public struct Temperature: Codable, Equatable, Hashable {

	/// The actually measured temperature
    public let actual: Double
	/// The feels-like temperature
    public let feelsLike: Double

	@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public var actualMeasurement: Measurement<UnitTemperature> {
		actualMeasurement(units: OpenWeather.shared.units)
	}

	@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public func actualMeasurement(units: WeatherResponse.Units) -> Measurement<UnitTemperature> {
		Measurement(value: actual, unit: units.temperatureUnit)
	}

	@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public var feelsLikeMeasurement: Measurement<UnitTemperature> {
		feelsLikeMeasurement(units: OpenWeather.shared.units)
	}

	@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public func feelsLikeMeasurement(units: WeatherResponse.Units) -> Measurement<UnitTemperature> {
		Measurement(value: feelsLike, unit: units.temperatureUnit)
	}

}
