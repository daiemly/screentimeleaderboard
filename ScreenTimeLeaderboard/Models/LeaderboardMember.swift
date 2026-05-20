import Foundation

struct LeaderboardMember: Identifiable, Hashable {
    let id: UUID
    var username: String
    var avatarSystemName: String
    var totalScreenTimeMinutes: Int
    var appBreakdown: [AppUsage]
    var reactions: [Reaction]
    var isCurrentUser: Bool
    var isTrackingPaused: Bool

    var topApp: AppUsage? {
        appBreakdown.max { $0.minutes < $1.minutes }
    }

    var formattedScreenTime: String {
        DurationFormatter.format(minutes: totalScreenTimeMinutes)
    }
}
