import Foundation
import HPNetwork

public protocol OpenWeatherRequest: NetworkRequest {

    var configuration: RequestConfiguration { get }

}

extension OpenWeatherRequest {

    var hasAPIKey: Bool {
        configuration.apiKey != nil
    }

}
