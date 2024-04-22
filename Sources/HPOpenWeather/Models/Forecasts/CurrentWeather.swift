import Foundation

public struct CurrentWeather: ForecastBase, SunForecast {

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case feelsLikeTemperature = "feels_like"
        case snow
        case rain
        case timestamp = "dt"
        case actualTemperature = "temp"
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
        case sunrise
        case sunset
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
    public let wind: Wind
    public let sun: Sun
    public let currentCondition: WeatherCondition
    public let temperature: Temperature

    // MARK: - Init

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let weatherArray = try container.decode([WeatherCondition].self, forKey: .weather)
        guard let currentCondition = weatherArray.first else {
            throw OpenWeatherError.noCurrentConditionReturned
        }
        self.currentCondition = currentCondition

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

        let sunrise = try container.decode(Date.self, forKey: .sunrise)
        let sunset = try container.decode(Date.self, forKey: .sunset)
        self.sun = Sun(sunset: sunset, sunrise: sunrise)
    }

}
