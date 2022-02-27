import Foundation

/// Type that holds information about wind speed and direction measured in degrees
public struct Wind: Codable, Equatable, Hashable {

    /// The current wind speed depending on the request's unit (metric: meter/second, imperial: miles/hour)
    public let speed: Double?
    /// Wind gust speed (metric: meter/sec, imperial: miles/hour)
    public let gust: Double?
    /// The wind direction measured in degrees from North
    public let degrees: Double?
    
    /// A measurement of the `speed` property if existing, measured in the units currently specified in `OpenWeather.shared`
    public var speedMeasurement: Measurement<UnitSpeed>? {
        speedMeasurement(units: OpenWeather.shared.units)
    }

    /// A measurement of the `speed` property if existing, measured in the passed in units
    /// - Parameter units: The units to use when formatting the `speed` property
    public func speedMeasurement(units: WeatherResponse.Units) -> Measurement<UnitSpeed>? {
        guard let speed = speed else {
            return nil
        }
        return Measurement(value: speed, unit: units.windSpeedUnit)
    }

}
