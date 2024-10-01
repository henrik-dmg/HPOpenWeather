import Foundation

public struct HourlyForecast: ForecastBase {

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case actualTemperature = "temp"
        case feelsLikeTemperature = "feels_like"
        case snow
        case rain
        case timestamp = "dt"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvIndex = "uvi"
        case cloudCoverage = "clouds"
        case visibility
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDirection = "wind_deg"
        case weather
    }

    // MARK: - Properties

    public let timestamp: Date
    public let pressure: Double?
    public let humidity: Double?
    public let dewPoint: Double?
    public let uvIndex: Double?
    public let visibility: Double?
    public let cloudCoverage: Double?
    public let rain: Precipitation?
    public let snow: Precipitation?
    public let temperature: Temperature
    public let wind: Wind
    public let condition: WeatherCondition

    // MARK: - Init

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let weatherArray = try container.decode([WeatherCondition].self, forKey: .weather)
        guard let condition = weatherArray.first else {
            throw OpenWeatherError.noCurrentConditionReturned
        }
        self.condition = condition

        self.snow = try container.decodeIfPresent(Precipitation.self, forKey: .snow)
        self.rain = try container.decodeIfPresent(Precipitation.self, forKey: .rain)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.pressure = try container.decodeIfPresent(Double.self, forKey: .pressure)
        self.humidity = try container.decodeIfPresent(Double.self, forKey: .humidity)
        self.dewPoint = try container.decodeIfPresent(Double.self, forKey: .dewPoint)
        self.uvIndex = try container.decodeIfPresent(Double.self, forKey: .uvIndex)
        self.cloudCoverage = try container.decodeIfPresent(Double.self, forKey: .cloudCoverage)
        self.visibility = try container.decodeIfPresent(Double.self, forKey: .visibility)

        let actualTemperature = try container.decode(Double.self, forKey: .actualTemperature)
        let feelsLikeTemperature = try container.decode(Double.self, forKey: .feelsLikeTemperature)
        self.temperature = Temperature(actual: actualTemperature, feelsLike: feelsLikeTemperature)

        let windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed)
        let windGust = try container.decodeIfPresent(Double.self, forKey: .windGust)
        let windDirection = try container.decodeIfPresent(Double.self, forKey: .windDirection)
        self.wind = Wind(speed: windSpeed, gust: windGust, degrees: windDirection)
    }

    // MARK: - Encoding

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(pressure, forKey: .pressure)
        try container.encodeIfPresent(humidity, forKey: .humidity)
        try container.encodeIfPresent(dewPoint, forKey: .dewPoint)
        try container.encodeIfPresent(uvIndex, forKey: .uvIndex)
        try container.encodeIfPresent(visibility, forKey: .visibility)
        try container.encodeIfPresent(cloudCoverage, forKey: .cloudCoverage)
        try container.encodeIfPresent(rain, forKey: .rain)
        try container.encodeIfPresent(snow, forKey: .snow)
        try container.encodeIfPresent([condition], forKey: .weather)

        try container.encodeIfPresent(temperature.actual, forKey: .actualTemperature)
        try container.encodeIfPresent(temperature.feelsLike, forKey: .feelsLikeTemperature)

        try container.encodeIfPresent(wind.gust, forKey: .windGust)
        try container.encodeIfPresent(wind.speed, forKey: .windSpeed)
        try container.encodeIfPresent(wind.degrees, forKey: .windDirection)
    }

}
