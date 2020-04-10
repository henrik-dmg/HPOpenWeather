import Foundation

public class BasicWeather: Decodable {

    public let timestamp: Date
    public let pressure: Double?
    public let humidity: Double?
    public let dewPoint: Double?
    public let uvIndex: Double?
    public let visibility: Double?
    public let cloudCoverage: Double?
    public let wind: Wind
//    public let rain: Precipitation?
//    public let snow: Precipitation?
    let weatherArray: [WeatherCondition]

    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidy
        case dewPoint = "dew_point"
        case uvIndex = "uvi"
        case cloudCoverage = "clouds"
        case visibility
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDirection = "wind_deg"
        case weatherArray = "weather"
        case rain
        case snow
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        timestamp = try container.decode(Date.self, forKey: .timestamp)

        pressure = try container.decodeIfPresent(Double.self, forKey: .pressure)
        humidity = try container.decodeIfPresent(Double.self, forKey: .humidy)
        dewPoint = try container.decodeIfPresent(Double.self, forKey: .dewPoint)
        uvIndex = try container.decodeIfPresent(Double.self, forKey: .uvIndex)
        visibility = try container.decodeIfPresent(Double.self, forKey: .visibility)
        cloudCoverage = try container.decodeIfPresent(Double.self, forKey: .cloudCoverage)

        let windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed)
        let windGust = try container.decodeIfPresent(Double.self, forKey: .windGust)
        let windDirection = try container.decodeIfPresent(Double.self, forKey: .windDirection)
        wind = Wind(speed: windSpeed, gust: windGust, degrees: windDirection)

//        rain = try container.decodeIfPresent(Precipitation.self, forKey: .rain)
//        snow = try container.decodeIfPresent(Precipitation.self, forKey: .snow)

        weatherArray = try container.decode([WeatherCondition].self, forKey: .weatherArray)
    }

}

public class BasicSunWeather: BasicWeather {

    public let sun: Sun

    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let sunrise = try container.decode(Date.self, forKey: .sunrise)
        let sunset = try container.decode(Date.self, forKey: .sunset)
        sun = Sun(sunset: sunset, sunrise: sunrise)

        try super.init(from: decoder)
    }

}
