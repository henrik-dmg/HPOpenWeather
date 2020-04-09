import Foundation
import HPNetwork

extension NSError {

    convenience init(domain: String = "com.henrikpanhans.HPOpenWeather", description: String, code: Int) {
        self.init(
            domain: domain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: description])
    }

}
