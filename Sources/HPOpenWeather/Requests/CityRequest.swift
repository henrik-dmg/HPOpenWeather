import Foundation
import HPNetwork

public class CityRequest<R: Decodable>: DecodableRequest<R>, WeatherRequest {

    public typealias Output = R

    public override var url: URL? {
        URLQueryItemsBuilder("api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent(requestType.rawValue)
            .addingQueryItem(cityComponents, name: "q")
            .addingQueryItem(configuration.apiKey, name: "appid")
            .addingQueryItem(configuration.units.rawValue, name: "units")
            .addingQueryItem(configuration.language.rawValue, name: "lang")
            .build()
    }

    public override var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    private let cityComponents: [String]

    public let configuration: RequestConfiguration
    public let requestType: RequestConfiguration.WeatherType

    init(
        cityComponents: [String],
        configuration: RequestConfiguration,
        requestType: RequestConfiguration.WeatherType)
    {
        self.cityComponents = cityComponents
        self.configuration = configuration
        self.requestType = requestType
        super.init(urlString: "www.google.com")
    }

    public init(
        cityComponents: [String],
        configuration: RequestConfiguration)
    {
        self.cityComponents = cityComponents
        self.configuration = configuration
        self.requestType = .current
        super.init(urlString: "www.google.com")
    }

}

extension CurrentWeather {

    public static func makeCityRequest(cityComponents: [String], configuration: RequestConfiguration) -> CityRequest<Self> {
        CityRequest<Self>(cityComponents: cityComponents, configuration: configuration, requestType: .current)
    }

}

extension HourlyForecast {

    public static func makeCityRequest(cityComponents: [String], configuration: RequestConfiguration) -> CityRequest<Self> {
        CityRequest<Self>(cityComponents: cityComponents, configuration: configuration, requestType: .oneHourlyForecast)
    }

}

extension DailyForecast {

    public static func makeCityRequest(cityComponents: [String], configuration: RequestConfiguration) -> CityRequest<Self> {
        CityRequest<Self>(cityComponents: cityComponents, configuration: configuration, requestType: .threeHourlyForecast)
    }

}
