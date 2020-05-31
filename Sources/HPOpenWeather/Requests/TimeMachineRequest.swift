import Foundation
import CoreLocation
import HPNetwork

public class TimeMachineRequest: DecodableRequest<TimeMachineResponse>, OpenWeatherRequest {

    public typealias Output = TimeMachineResponse

    public override var url: URL? {
        URLQueryItemsBuilder(host: "api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent("onecall")
            .addingPathComponent("timemachine")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
            .addingQueryItem("\(Int(date.timeIntervalSince1970))", name: "dt")
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
    private let date: Date

    public let configuration: RequestConfiguration

    /// Returns nil, if `date` is less than 6 hours before current date
    public init?(coordinate: CLLocationCoordinate2D, date: Date, configuration: RequestConfiguration) {
        guard date.timeIntervalSinceNow < -6 * .hour else {
            return nil
        }

        self.coordinate = coordinate
        self.date = date
        self.configuration = configuration
        super.init(urlString: "www.google.com")
    }

}
