import Foundation

public struct DailyForecast: ForecastBase, SunForecast, MoonForecast {

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case feelsLikeTemperature = "feels_like"
        case totalRain = "rain"
        case totalSnow = "snow"
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
        case weather
        case sunrise
        case sunset
        case moonrise
        case moonset
    }

    // MARK: - Properties

    public let temperature: DailyTemperature
    public let feelsLikeTemperature: DailyTemperature
    public let totalRain: Double?
    public let totalSnow: Double?

    public let timestamp: Date
    public let pressure: Double?
    public let humidity: Double?
    public let dewPoint: Double?
    public let uvIndex: Double?
    public let visibility: Double?
    public let cloudCoverage: Double?
    public let condition: WeatherCondition
    public let sun: Sun
    public let wind: Wind
    public let moon: Moon

    // MARK: - Init

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let weatherArray = try container.decode([WeatherCondition].self, forKey: .weather)
        guard let condition = weatherArray.first else {
            throw OpenWeatherError.noCurrentConditionReturned
        }
        self.condition = condition

        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.pressure = try container.decodeIfPresent(Double.self, forKey: .pressure)
        self.humidity = try container.decodeIfPresent(Double.self, forKey: .humidity)
        self.dewPoint = try container.decodeIfPresent(Double.self, forKey: .dewPoint)
        self.uvIndex = try container.decodeIfPresent(Double.self, forKey: .uvIndex)
        self.cloudCoverage = try container.decodeIfPresent(Double.self, forKey: .cloudCoverage)
        self.visibility = try container.decodeIfPresent(Double.self, forKey: .visibility)
        self.temperature = try container.decode(DailyTemperature.self, forKey: .temperature)
        self.feelsLikeTemperature = try container.decode(DailyTemperature.self, forKey: .feelsLikeTemperature)
        self.totalRain = try container.decodeIfPresent(Double.self, forKey: .totalRain)
        self.totalSnow = try container.decodeIfPresent(Double.self, forKey: .totalSnow)

        let windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed)
        let windGust = try container.decodeIfPresent(Double.self, forKey: .windGust)
        let windDirection = try container.decodeIfPresent(Double.self, forKey: .windDirection)
        self.wind = Wind(speed: windSpeed, gust: windGust, degrees: windDirection)

        let sunrise = try container.decode(Date.self, forKey: .sunrise)
        let sunset = try container.decode(Date.self, forKey: .sunset)
        self.sun = Sun(sunset: sunset, sunrise: sunrise)

        let moonrise = try container.decode(Date.self, forKey: .moonrise)
        let moonset = try container.decode(Date.self, forKey: .moonset)
        self.moon = Moon(moonset: moonset, moonrise: moonrise)
    }

}

