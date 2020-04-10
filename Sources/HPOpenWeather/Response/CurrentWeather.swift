import Foundation

public class CurrentWeather: BasicSunWeather {

    public var condition: WeatherCondition {
        weatherArray.first ?? WeatherCondition.unknown
    }

    public let temperature: Temperature

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let temp = try container.decode(Double.self, forKey: .temp)
        let feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        temperature = Temperature(actual: temp, feelsLike: feelsLike)

        try super.init(from: decoder)
    }

}
