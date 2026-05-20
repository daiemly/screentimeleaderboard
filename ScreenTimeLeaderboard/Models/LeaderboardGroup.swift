import Foundation

struct LeaderboardGroup: Identifiable, Hashable {
    let id: UUID
    var name: String
    var inviteCode: String
    var members: [LeaderboardMember]
    var isLocked: Bool
    var lockedAt: Date?

    var rankedMembers: [LeaderboardMember] {
        members.sorted { lhs, rhs in
            if lhs.isTrackingPaused != rhs.isTrackingPaused {
                return !lhs.isTrackingPaused
            }
            return lhs.totalScreenTimeMinutes < rhs.totalScreenTimeMinutes
        }
    }

    var winner: LeaderboardMember? {
        rankedMembers.first { !$0.isTrackingPaused }
    }

    var groupAverageMinutes: Int {
        let activeMembers = members.filter { !$0.isTrackingPaused }
        guard !activeMembers.isEmpty else { return 0 }
        let total = activeMembers.map(\.totalScreenTimeMinutes).reduce(0, +)
        return total / activeMembers.count
    }

    var highestScreenTimeMember: LeaderboardMember? {
        members
            .filter { !$0.isTrackingPaused }
            .max { $0.totalScreenTimeMinutes < $1.totalScreenTimeMinutes }
    }

    var mostUsedApp: AppUsage? {
        members
            .flatMap(\.appBreakdown)
            .max { $0.minutes < $1.minutes }
    }
}
