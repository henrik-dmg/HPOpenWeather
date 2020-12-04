import Foundation
import HPNetwork

extension NSError {

    convenience init(domain: String = "com.henrikpanhans.HPOpenWeather", code: Int, description: String) {
        self.init(
            domain: domain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: description]
		)
    }

}
