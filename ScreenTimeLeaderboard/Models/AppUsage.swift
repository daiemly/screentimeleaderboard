import Foundation

struct AppUsage: Identifiable, Hashable {
    let id = UUID()
    var appName: String
    var minutes: Int

    var formattedDuration: String {
        DurationFormatter.format(minutes: minutes)
    }
}
