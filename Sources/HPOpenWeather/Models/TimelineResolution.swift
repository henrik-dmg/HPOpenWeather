import Foundation

/// The time step between the entries of a One Call 4.0 timeline.
enum TimelineResolution: String, Codable, Hashable, Sendable {

    case minute = "1min"
    case quarterHour = "15min"
    case hour = "1h"
    case day = "1day"

}
