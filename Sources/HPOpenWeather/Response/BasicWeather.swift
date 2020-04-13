import Foundation

public protocol BasicWeatherResponse: Codable, Hashable {

    var timestamp: Date { get }
    var pressure: Double? { get }
    var humidity: Double? { get }
    var dewPoint: Double? { get }
    var uvIndex: Double? { get }
    var visibility: Double? { get }
    var cloudCoverage: Double? { get }
    var wind: Wind { get }

}

public protocol SunResponse: Codable, Hashable {

    var sun: Sun { get }

}


public class BasicWeather: Codable {

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
        case humidity
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

    internal init(
        timestamp: Date,
        pressure: Double?,
        humidity: Double?,
        dewPoint: Double?,
        uvIndex: Double?,
        visibility: Double?,
        cloudCoverage: Double?,
        wind: Wind,
        weatherArray: [WeatherCondition])
    {
        self.timestamp = timestamp
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.uvIndex = uvIndex
        self.visibility = visibility
        self.cloudCoverage = cloudCoverage
        self.wind = wind
        self.weatherArray = weatherArray
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        timestamp = try container.decode(Date.self, forKey: .timestamp)

        pressure = try container.decodeIfPresent(Double.self, forKey: .pressure)
        humidity = try container.decodeIfPresent(Double.self, forKey: .humidity)
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(dewPoint, forKey: .uvIndex)
        try container.encode(visibility, forKey: .cloudCoverage)
        try container.encode(dewPoint, forKey: .uvIndex)
        try container.encode(visibility, forKey: .cloudCoverage)

        try container.encode(wind.speed, forKey: .windSpeed)
        try container.encode(wind.degrees, forKey: .windDirection)
        try container.encode(wind.gust, forKey: .windGust)

        try container.encode(weatherArray, forKey: .weatherArray)
    }

}

public class BasicSunWeather: BasicWeather {

    public let sun: Sun

    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
    }

    internal init(
        sun: Sun,
        timestamp: Date,
        pressure: Double?,
        humidity: Double?,
        dewPoint: Double?,
        uvIndex: Double?,
        visibility: Double?,
        cloudCoverage: Double?,
        wind: Wind,
        weatherArray: [WeatherCondition])
    {
        self.sun = sun
        super.init(
            timestamp: timestamp,
            pressure: pressure,
            humidity: humidity,
            dewPoint: dewPoint,
            uvIndex: uvIndex,
            visibility: visibility,
            cloudCoverage: cloudCoverage,
            wind: wind,
            weatherArray: weatherArray)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let sunrise = try container.decode(Date.self, forKey: .sunrise)
        let sunset = try container.decode(Date.self, forKey: .sunset)
        sun = Sun(sunset: sunset, sunrise: sunrise)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(sun.sunset, forKey: .sunrise)
        try container.encode(sun.sunrise, forKey: .sunrise)

        try super.encode(to: encoder)
    }

}
