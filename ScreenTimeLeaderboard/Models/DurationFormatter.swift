import Foundation

enum DurationFormatter {
    static func format(minutes: Int) -> String {
        let hours = minutes / 60
        let remainder = minutes % 60

        if hours == 0 {
            return "\(remainder)m"
        }

        if remainder == 0 {
            return "\(hours)h"
        }

        return "\(hours)h \(remainder)m"
    }
}
