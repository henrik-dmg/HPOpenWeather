import CoreLocation
import Foundation

/// An endpoint of the One Call API 4.0.
enum OneCallEndpoint: Sendable {

    case current(coordinate: CLLocationCoordinate2D)
    case timeline(resolution: TimelineResolution, coordinate: CLLocationCoordinate2D, startDate: Date?)
    case alert(id: String)

    // MARK: - Computed Properties

    /// The path of the endpoint, relative to `data/4.0/onecall`.
    var path: String {
        switch self {
        case .current:
            return "current"
        case .timeline(let resolution, _, _):
            return "timeline/\(resolution.rawValue)"
        case .alert(let id):
            return "alert/\(id)"
        }
    }

    var coordinate: CLLocationCoordinate2D? {
        switch self {
        case .current(let coordinate), .timeline(_, let coordinate, _):
            return coordinate
        case .alert:
            return nil
        }
    }

    var startDate: Date? {
        switch self {
        case .timeline(_, _, let startDate):
            return startDate
        case .current, .alert:
            return nil
        }
    }

    /// Tells if the endpoint accepts the `units` and `lang` query parameters.
    var isLocalized: Bool {
        switch self {
        case .current, .timeline:
            return true
        case .alert:
            return false
        }
    }

}
