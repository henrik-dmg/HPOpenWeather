import Foundation

extension KeyedDecodingContainer {

    /// Decodes a sun or moon timestamp, if available.
    ///
    /// The API sends `0` when the event does not occur on that day, for example during the polar night.
    /// This method returns `nil` for a missing value and for `0`.
    func decodeEventTimestampIfPresent(forKey key: Key) throws -> Date? {
        guard let date = try decodeIfPresent(Date.self, forKey: key), date.timeIntervalSince1970 != 0 else {
            return nil
        }
        return date
    }

}
