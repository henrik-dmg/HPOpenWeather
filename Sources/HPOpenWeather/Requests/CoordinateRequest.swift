import Foundation
import CoreLocation
import HPNetwork

public class CoordinateRequest<R: Decodable>: DecodableRequest<R>, WeatherRequest {

    public typealias Output = R

    public override var url: URL? {
        URLQueryItemsBuilder("api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent(requestType.rawValue)
            .addingQueryItem(coordinate.latitude, name: "lat", digits: 5)
            .addingQueryItem(coordinate.longitude, name: "lon", digits: 5)
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

    private let coordinate: CLLocationCoordinate2D

    public let configuration: RequestConfiguration
    public let requestType: RequestConfiguration.WeatherType

    init(
        coordinate: CLLocationCoordinate2D,
        configuration: RequestConfiguration,
        requestType: RequestConfiguration.WeatherType)
    {
        self.coordinate = coordinate
        self.configuration = configuration
        self.requestType = requestType
        super.init(urlString: "www.google.com")
    }

    public init(
        coordinate: CLLocationCoordinate2D,
        configuration: RequestConfiguration)
    {
        self.coordinate = coordinate
        self.configuration = configuration
        self.requestType = .current
        super.init(urlString: "www.google.com")
    }

}

extension CurrentWeather {

    public static func makeCoordinateRequest(coordinate: CLLocationCoordinate2D, configuration: RequestConfiguration) -> CoordinateRequest<Self> {
        CoordinateRequest<Self>(coordinate: coordinate, configuration: configuration, requestType: .current)
    }

}

extension HourlyForecast {

    public static func makeCoordinateRequest(coordinate: CLLocationCoordinate2D, configuration: RequestConfiguration) -> CoordinateRequest<Self> {
        CoordinateRequest<Self>(coordinate: coordinate, configuration: configuration, requestType: .oneHourlyForecast)
    }

}

extension DailyForecast {

    public static func makeCoordinateRequest(coordinate: CLLocationCoordinate2D, configuration: RequestConfiguration) -> CoordinateRequest<Self> {
        CoordinateRequest<Self>(coordinate: coordinate, configuration: configuration, requestType: .threeHourlyForecast)
    }

}
