import CoreLocation
import Foundation

public struct CurrentWeather: WeatherSnapshot {

    // Already has documentation
    public let cloudCoverage: Int
    public let timeOfCalculation: Date
    public let main: Main
    public let condition: WeatherCondition
    public let wind: Wind
    public let snow: Precipitation
    public let rain: Precipitation
    public let system: System
    /// The location coordinates of the request
    public let coordinate: CLLocationCoordinate2D

    /// Represents the city returned in the request
    public var city: City {
        City(id: _cityId, name: _name, location: coordinate, countryCode: system.countryCode)
    }

    /// Holds information about sunset und sunrise times in UTC time at the location of the request
    public var sun: Sun {
        Sun(sunSet: system.sunset, sunRise: system.sunrise)
    }

    /// The ID of the nearest city
    internal let _cityId: Int
    /// The name of the nearest city
    internal let _name: String

    enum CodingKeys: String, CodingKey {
        case _cityId = "id"
        case _name = "name"
        case timeOfCalculation = "dt"
        case coordinate = "coord"
        case system = "sys"
        case main
        case wind
        case snow
        case rain
        case cloudCoverage
        case condition = "weather"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        cloudCoverage = try container.decodeIfPresent(Clouds.self, forKey: .cloudCoverage)?.all ?? 0
        timeOfCalculation = try container.decode(Date.self, forKey: .timeOfCalculation)
        main = try container.decode(Main.self, forKey: .main)
        condition = try container.decodeIfPresent([WeatherCondition].self, forKey: .condition)?.first ?? WeatherCondition.unknown
        wind = try container.decode(Wind.self, forKey: .wind)
        snow = try container.decodeIfPresent(Precipitation.self, forKey: .snow) ?? Precipitation.none
        rain = try container.decodeIfPresent(Precipitation.self, forKey: .rain) ?? Precipitation.none
        system = try container.decode(System.self, forKey: .system)
        _cityId = try container.decode(Int.self, forKey: ._cityId)
        coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
        _name = try container.decode(String.self, forKey: ._name)
    }

}
