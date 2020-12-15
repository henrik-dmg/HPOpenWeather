import Foundation

public struct HourlyForecast: BasicWeatherResponse {

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
		case weatherArray = "weather"
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

	// Temperature

	private let actualTemperature: Double
	private let feelsLikeTemperature: Double

	public var temperature: Temperature {
		Temperature(actual: actualTemperature, feelsLike: feelsLikeTemperature)
	}

	// Wind

	private let windSpeed: Double?
	private let windGust: Double?
	private let windDirection: Double?

	public var wind: Wind {
		Wind(speed: windSpeed, gust: windGust, degrees: windDirection)
	}

	// Weather

    private let weatherArray: [WeatherCondition]

    public var weather: [WeatherCondition] {
        weatherArray
    }

}
