import Foundation
import CoreLocation
import HPNetwork

extension NSError {

    static let noApiKey = NSError(description: "API key was not provided", code: 2)
    static let timeMachineDate = NSError(description: "TimeMachineRequest's date has to be at least 6 hours in the past", code: 3)

}

public struct WeatherRequest: OpenWeatherRequest {

    public typealias Output = WeatherResponse

    public let coordinate: CLLocationCoordinate2D

    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    public func makeNetworkRequest(settings: HPOpenWeather.Settings) throws -> DecodableRequest<WeatherResponse> {
        WeatherNetworkRequest(request: self, settings: settings)
    }
    
}

class WeatherNetworkRequest: DecodableRequest<WeatherResponse> {

    public typealias Output = WeatherResponse

    public override var url: URL? {
        URLQueryItemsBuilder(host: "api.openweathermap.org")
            .addingPathComponent("data")
            .addingPathComponent("2.5")
            .addingPathComponent("onecall")
            .addingQueryItem(coordinate.latitude, digits: 5, name: "lat")
            .addingQueryItem(coordinate.longitude, digits: 5, name: "lon")
            .addingQueryItem(settings.apiKey, name: "appid")
            .addingQueryItem(settings.units.rawValue, name: "units")
            .addingQueryItem(settings.language.rawValue, name: "lang")
            .build()
    }

    public override var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    private let coordinate: CLLocationCoordinate2D
    private let settings: HPOpenWeather.Settings

    init(request: WeatherRequest, settings: HPOpenWeather.Settings) {
        self.coordinate = request.coordinate
        self.settings = settings
        super.init(urlString: "www.google.com")
    }

}

extension Double {

    static let minute = 60.00
    static let hour = 3600.00
    static let day = 86400.00

}
