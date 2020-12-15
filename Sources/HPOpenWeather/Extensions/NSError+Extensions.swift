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

	static let noApiKey = NSError(code: 2, description: "API key was not provided")
	static let timeMachineDate = NSError(code: 3, description: "TimeMachineRequest's date has to be at least 6 hours in the past")

}
