import Foundation

/// The units that should the data in the API responses should be formatted in
public enum RequestUnits: String {

	/// Temperature in Kelvin and wind speed in meter/sec
	case standard
	/// Temperature in Celsius and wind speed in meter/sec
    case metric
	/// Temperature in Fahrenheit and wind speed in miles/hour
    case imperial

}
