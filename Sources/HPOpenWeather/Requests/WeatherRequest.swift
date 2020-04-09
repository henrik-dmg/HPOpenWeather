import Foundation
import HPNetwork

public protocol WeatherRequest: NetworkRequest {

    var configuration: RequestConfiguration { get }
    var requestType: RequestConfiguration.WeatherType { get }

}

extension WeatherRequest {

    var hasAPIKey: Bool {
        configuration.apiKey != nil
    }

}
