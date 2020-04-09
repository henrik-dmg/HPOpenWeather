import Foundation

/// Type that holds the main information of the request, such as temperature, humidity, etc.
public struct Main: Codable, Equatable, Hashable {

    /// The current temperature in the format specified in the request
    public let temperature: Double
    /// The minimum temperature reached on the day of the request
    public let temperatureMin: Double
    /// The maximum temperature reached on the day of the request
    public let temperatureMax: Double
    /// The current humidity measured in percent
    public let humidity: Int
    /// The current air pressure measured in hPa
    public let pressure: Double
    /// The current sea level pressure measured in hPa (Note: Is zero when data is unavailable)
    public let seaLevelPressure: Double?
    /// The current ground level pressure measured in hPa (Note: Is zero when data is unavailable)
    public let groundLevelPressure: Double?

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
        case pressure
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case seaLevelPressure = "sea_level"
        case groundLevelPressure = "grnd_level"
    }

}
