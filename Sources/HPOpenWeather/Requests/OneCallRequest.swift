import Foundation
import HPNetwork
import HPURLBuilder

/// A request to an endpoint of the One Call API 4.0.
struct OneCallRequest<Output: Decodable>: DecodableRequest {

    // MARK: - Properties

    let endpoint: OneCallEndpoint
    let settings: OpenWeather.Settings

    let requestMethod: HTTPRequest.Method = .get

    // MARK: - Computed Properties

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }

    // MARK: - Methods

    func makeURL() throws -> URL {
        try URL.buildThrowing {
            Host("api.openweathermap.org")
            PathComponent("data")
            PathComponent("4.0")
            PathComponent("onecall")
            PathComponent(endpoint.path)
            QueryItem(name: "lat", value: endpoint.coordinate?.latitude, digits: 5)
            QueryItem(name: "lon", value: endpoint.coordinate?.longitude, digits: 5)
            QueryItem(name: "start", value: endpoint.startDate.map { Int($0.timeIntervalSince1970) })
            QueryItem(name: "appid", value: settings.apiKey)
            QueryItem(name: "units", value: endpoint.isLocalized ? settings.units.rawValue : nil)
            QueryItem(name: "lang", value: endpoint.isLocalized ? settings.language.rawValue : nil)
        }
    }

    func convertResponse(data: Data, response: HTTPResponse) throws -> Output {
        switch response.status.kind {
        case .informational, .successful:
            return try decoder.decode(Output.self, from: data)
        case .clientError, .invalid, .redirection, .serverError:
            var errorToThrow: any Error
            do {
                errorToThrow = try decoder.decode(OpenWeatherAPIError.self, from: data)
            } catch {
                errorToThrow = URLError(URLError.Code(rawValue: response.status.code))
            }
            throw errorToThrow
        }
    }

    func validateResponse(_ response: HTTPResponse) throws {
        // Do nothing. The convertResponse method validates the response.
    }

}
