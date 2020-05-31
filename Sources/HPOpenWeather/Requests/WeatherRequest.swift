import Foundation
import CoreLocation
import HPNetwork

public class WeatherRequest: DecodableRequest<WeatherResponse>, OpenWeatherRequest {

    public typealias Output = WeatherResponse

    public override var url: URL? {
        URLQueryItemsBuilder(host: "api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent("onecall")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
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

    public init(coordinate: CLLocationCoordinate2D, configuration: RequestConfiguration) {
        self.coordinate = coordinate
        self.configuration = configuration
        super.init(urlString: "www.google.com")
    }

}

extension Double {

    static let minute = 60.00
    static let hour = 3600.00
    static let day = 86400.00

}
