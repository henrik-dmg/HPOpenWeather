import Foundation

public protocol ForecastBase: Decodable, Hashable {

    /// The timestamp when the data was collected.
    var timestamp: Date { get }
    /// Atmospheric pressure on the sea level, hPa.
    var pressure: Double? { get }
    /// Humidity in percent.
    var humidity: Double? { get }
    /// Atmospheric temperature (varying according to pressure and humidity) below which water droplets begin to condense and dew can form.
    ///
    /// Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    var dewPoint: Double? { get }
    /// UV index.
    var uvIndex: Double? { get }
    /// Average visibility.
    var visibility: Double? { get }
    /// Cloudiness in percent.
    var cloudCoverage: Double? { get }
    /// Basic information about observed wind.
    var wind: Wind { get }

}

public protocol SunForecast: Decodable, Hashable {

    /// A container that holds information about sunset and sunrise timestamps.
    var sun: Sun { get }

}

public protocol MoonForecast: Decodable, Hashable {

    /// A container that holds information about moonrise and moonset timestamps.
    var moon: Moon { get }

}
