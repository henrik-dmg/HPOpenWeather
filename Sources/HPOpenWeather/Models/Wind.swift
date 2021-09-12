import Foundation

/// Type that holds information about wind speed and direction measured in degrees
public struct Wind: Codable, Equatable, Hashable {

    /// The current wind speed depending on the request's unit (metric: meter/second, imperial: miles/hour)
    public let speed: Double?
    /// Wind gust speed (metric: meter/sec, imperial: miles/hour)
    public let gust: Double?
    /// The wind direction measured in degrees from North
    public let degrees: Double?

	@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public var speedMeasurement: Measurement<UnitSpeed>? {
		speedMeasurement(units: OpenWeather.shared.units)
	}

	@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public func speedMeasurement(units: WeatherResponse.Units) -> Measurement<UnitSpeed>? {
		guard let speed = speed else {
			return nil
		}
		return Measurement(value: speed, unit: units.windSpeedUnit)
	}

}
