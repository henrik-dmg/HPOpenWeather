import Foundation
import HPNetwork

public class ZipCodeRequest<R: Decodable>: DecodableRequest<R>, WeatherRequest {

    public typealias Output = R

    public override var url: URL? {
        URLQueryItemsBuilder("api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent(requestType.rawValue)
            .addingQueryItem([zipCode, countryCode], name: "zip")
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

    private let zipCode: String
    private let countryCode: String

    public let configuration: RequestConfiguration
    public let requestType: RequestConfiguration.WeatherType

    init(
        zipCode: String,
        countryCode: String,
        configuration: RequestConfiguration,
        requestType: RequestConfiguration.WeatherType)
    {
        self.zipCode = zipCode
        self.countryCode = countryCode
        self.configuration = configuration
        self.requestType = requestType
        super.init(urlString: "www.google.com")
    }

    public init(
        zipCode: String,
        countryCode: String,
        configuration: RequestConfiguration)
    {
        self.zipCode = zipCode
        self.countryCode = countryCode
        self.configuration = configuration
        self.requestType = .current
        super.init(urlString: "www.google.com")
    }

}

extension CurrentWeather {

    public static func makeCoordinateRequest(zipCode: String, countryCode: String, configuration: RequestConfiguration) -> ZipCodeRequest<Self> {
        ZipCodeRequest<Self>(zipCode: zipCode, countryCode: countryCode, configuration: configuration, requestType: .current)
    }

}

extension HourlyForecast {

    public static func makeCoordinateRequest(zipCode: String, countryCode: String, configuration: RequestConfiguration) -> ZipCodeRequest<Self> {
        ZipCodeRequest<Self>(zipCode: zipCode, countryCode: countryCode, configuration: configuration, requestType: .oneHourlyForecast)
    }

}

extension DailyForecast {

    public static func makeCoordinateRequest(zipCode: String, countryCode: String, configuration: RequestConfiguration) -> ZipCodeRequest<Self> {
        ZipCodeRequest<Self>(zipCode: zipCode, countryCode: countryCode, configuration: configuration, requestType: .threeHourlyForecast)
    }

}
