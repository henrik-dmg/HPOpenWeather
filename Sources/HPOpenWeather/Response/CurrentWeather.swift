import Foundation

public struct CurrentWeather: BasicWeatherResponse, SunResponse {

    public let timestamp: Date
    public let pressure: Double?
    public let humidity: Double?
    public let dewPoint: Double?
    public let uvIndex: Double?
    public let visibility: Double?
    public let cloudCoverage: Double?
    public let wind: Wind
    public let temperature: Temperature
    public let rain: Precipitation
    public let snow: Precipitation
    public let sun: Sun
    private let weatherArray: [WeatherCondition]

    public var condition: WeatherCondition {
        weatherArray.first ?? WeatherCondition.unknown
    }

    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case snow
        case rain
        case timestamp = "dt"
        case temperature = "temp"
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
        case sunrise
        case sunset
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        snow = try container.decodeIfPresent(Precipitation.self, forKey: .snow) ?? Precipitation.none
        rain = try container.decodeIfPresent(Precipitation.self, forKey: .rain) ?? Precipitation.none
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        weatherArray = try container.decode([WeatherCondition].self, forKey: .weatherArray)
        pressure = try container.decodeIfPresent(Double.self, forKey: .pressure)
        humidity = try container.decodeIfPresent(Double.self, forKey: .humidity)
        dewPoint = try container.decodeIfPresent(Double.self, forKey: .dewPoint)
        uvIndex = try container.decodeIfPresent(Double.self, forKey: .uvIndex)
        visibility = try container.decodeIfPresent(Double.self, forKey: .visibility)
        cloudCoverage = try container.decodeIfPresent(Double.self, forKey: .cloudCoverage)

        let temp = try container.decode(Double.self, forKey: .temperature)
        let feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        temperature = Temperature(actual: temp, feelsLike: feelsLike)

        let windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed)
        let windGust = try container.decodeIfPresent(Double.self, forKey: .windGust)
        let windDirection = try container.decodeIfPresent(Double.self, forKey: .windDirection)
        wind = Wind(speed: windSpeed, gust: windGust, degrees: windDirection)

        let sunrise = try container.decode(Date.self, forKey: .sunrise)
        let sunset = try container.decode(Date.self, forKey: .sunset)
        sun = Sun(sunset: sunset, sunrise: sunrise)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(temperature.actual, forKey: .temperature)
        try container.encode(temperature.feelsLike, forKey: .feelsLike)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(dewPoint, forKey: .dewPoint)
        try container.encode(uvIndex, forKey: .uvIndex)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(cloudCoverage, forKey: .cloudCoverage)
        try container.encode(rain, forKey: .rain)
        try container.encode(snow, forKey: .snow)

        try container.encode(wind.speed, forKey: .windSpeed)
        try container.encode(wind.degrees, forKey: .windDirection)
        try container.encode(wind.gust, forKey: .windGust)
        try container.encode(sun.sunset, forKey: .sunset)
        try container.encode(sun.sunrise, forKey: .sunrise)
        try container.encode(weatherArray, forKey: .weatherArray)
    }

}
