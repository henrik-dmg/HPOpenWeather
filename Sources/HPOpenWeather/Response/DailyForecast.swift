import Foundation

public class DailyForecast: BasicSunWeather {

    public var weather: [WeatherCondition] {
        weatherArray
    }

    public let temperature: DailyTemperature
    public let feelsLikeTemperature: DailyTemperature
    public let totalRain: Double?
    public let totalSnow: Double?

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case rain
        case snow
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        temperature = try container.decode(DailyTemperature.self, forKey: .temperature)
        feelsLikeTemperature = try container.decode(DailyTemperature.self, forKey: .feelsLike)
        totalRain = try container.decodeIfPresent(Double.self, forKey: .rain)
        totalSnow = try container.decodeIfPresent(Double.self, forKey: .snow)

        try super.init(from: decoder)
    }

}

