import Foundation

public class HourlyForecast: BasicWeather {

    public var weather: [WeatherCondition] {
        weatherArray
    }

    public let temperature: Temperature
    public let rain: Precipitation
    public let snow: Precipitation

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case snow
        case rain
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let temp = try container.decode(Double.self, forKey: .temp)
        let feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        temperature = Temperature(actual: temp, feelsLike: feelsLike)

        snow = try container.decodeIfPresent(Precipitation.self, forKey: .snow) ?? Precipitation.none
        rain = try container.decodeIfPresent(Precipitation.self, forKey: .rain) ?? Precipitation.none

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(temperature.actual, forKey: .temp)
        try container.encode(temperature.feelsLike, forKey: .feelsLike)
        try container.encode(snow, forKey: .snow)
        try container.encode(rain, forKey: .rain)

        try super.encode(to: encoder)
    }

}
