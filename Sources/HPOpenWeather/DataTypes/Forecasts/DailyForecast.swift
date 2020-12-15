import Foundation

public struct DailyForecast: BasicWeatherResponse, SunResponse {

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
		case weatherArray = "weather"
		case sunrise
		case sunset
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

	// Weather Conditions

    private let weatherArray: [WeatherCondition]

    public var condition: WeatherCondition? {
        weatherArray.first
    }

	// Wind

	private let windSpeed: Double?
	private let windGust: Double?
	private let windDirection: Double?

	public var wind: Wind {
		Wind(speed: windSpeed, gust: windGust, degrees: windDirection)
	}

	// Sun

	private let sunrise: Date
	private let sunset: Date

	public var sun: Sun {
		Sun(sunset: sunset, sunrise: sunrise)
	}

}

