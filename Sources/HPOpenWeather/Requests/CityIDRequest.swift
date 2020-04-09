import Foundation
import HPNetwork

public class CityIDRequest<R: Decodable>: DecodableRequest<R>, WeatherRequest {

    public typealias Output = R

    public override var url: URL? {
        URLQueryItemsBuilder("api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent(requestType.rawValue)
            .addingQueryItem(cityID, name: "id")
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

    private let cityID: String

    public let configuration: RequestConfiguration
    public let requestType: RequestConfiguration.WeatherType

    init(
        cityID: String,
        configuration: RequestConfiguration,
        requestType: RequestConfiguration.WeatherType)
    {
        self.cityID = cityID
        self.configuration = configuration
        self.requestType = requestType
        super.init(urlString: "www.google.com")
    }

    public init(
        cityID: String,
        configuration: RequestConfiguration)
    {
        self.cityID = cityID
        self.configuration = configuration
        self.requestType = .current
        super.init(urlString: "www.google.com")
    }

}

extension CurrentWeather {

    public static func makeCityIDRequest(cityID: String, configuration: RequestConfiguration) -> CityIDRequest<Self> {
        CityIDRequest<Self>(cityID: cityID, configuration: configuration, requestType: .current)
    }

}

extension HourlyForecast {

    public static func makeCityIDRequest(cityID: String, configuration: RequestConfiguration) -> CityIDRequest<Self> {
        CityIDRequest<Self>(cityID: cityID, configuration: configuration, requestType: .oneHourlyForecast)
    }

}

extension DailyForecast {

    public static func makeCityIDRequest(cityID: String, configuration: RequestConfiguration) -> CityIDRequest<Self> {
        CityIDRequest<Self>(cityID: cityID, configuration: configuration, requestType: .threeHourlyForecast)
    }

}
