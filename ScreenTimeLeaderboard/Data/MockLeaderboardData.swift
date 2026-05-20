import Foundation

enum MockLeaderboardData {
    static let currentUser = UserProfile(
        id: UUID(uuidString: "41B83B85-B767-41CD-B6BA-2677F79924C3")!,
        username: "daiem",
        avatarSystemName: "person.crop.circle.fill"
    )

    static let groups: [LeaderboardGroup] = [
        LeaderboardGroup(
            id: UUID(uuidString: "A4D33947-0E9D-44D7-82D2-5E18DF742E81")!,
            name: "Close Friends",
            inviteCode: "SCREEN-4281",
            members: [
                LeaderboardMember(
                    id: UUID(uuidString: "3837ACF1-59BB-4ED1-8CB0-7C1FCA270695")!,
                    username: "Sarah",
                    avatarSystemName: "person.crop.circle.fill",
                    totalScreenTimeMinutes: 131,
                    appBreakdown: [
                        AppUsage(appName: "Spotify", minutes: 42),
                        AppUsage(appName: "Messages", minutes: 31),
                        AppUsage(appName: "Safari", minutes: 24),
                        AppUsage(appName: "Photos", minutes: 18)
                    ],
                    reactions: [.respect, .caught],
                    isCurrentUser: false,
                    isTrackingPaused: false
                ),
                LeaderboardMember(
                    id: MockLeaderboardData.currentUser.id,
                    username: MockLeaderboardData.currentUser.username,
                    avatarSystemName: MockLeaderboardData.currentUser.avatarSystemName,
                    totalScreenTimeMinutes: 254,
                    appBreakdown: [
                        AppUsage(appName: "YouTube", minutes: 83),
                        AppUsage(appName: "Instagram", minutes: 57),
                        AppUsage(appName: "Messages", minutes: 36),
                        AppUsage(appName: "Safari", minutes: 31)
                    ],
                    reactions: [.wild],
                    isCurrentUser: true,
                    isTrackingPaused: false
                ),
                LeaderboardMember(
                    id: UUID(uuidString: "EC1C5F9C-2D8F-4744-AB18-425A02EE6F41")!,
                    username: "Alex",
                    avatarSystemName: "person.crop.circle.fill",
                    totalScreenTimeMinutes: 652,
                    appBreakdown: [
                        AppUsage(appName: "TikTok", minutes: 374),
                        AppUsage(appName: "YouTube", minutes: 118),
                        AppUsage(appName: "Snapchat", minutes: 69),
                        AppUsage(appName: "Messages", minutes: 41)
                    ],
                    reactions: [.cooked, .cooked, .wild],
                    isCurrentUser: false,
                    isTrackingPaused: false
                ),
                LeaderboardMember(
                    id: UUID(uuidString: "BE9C8B6D-613A-406F-B494-2E45261FA44C")!,
                    username: "Maya",
                    avatarSystemName: "person.crop.circle.fill",
                    totalScreenTimeMinutes: 0,
                    appBreakdown: [],
                    reactions: [],
                    isCurrentUser: false,
                    isTrackingPaused: true
                )
            ],
            isLocked: false,
            lockedAt: nil
        ),
        LeaderboardGroup(
            id: UUID(uuidString: "0C844102-CF10-472E-9197-A0E23DF93E88")!,
            name: "Roommates",
            inviteCode: "SCREEN-8804",
            members: [
                LeaderboardMember(
                    id: MockLeaderboardData.currentUser.id,
                    username: MockLeaderboardData.currentUser.username,
                    avatarSystemName: MockLeaderboardData.currentUser.avatarSystemName,
                    totalScreenTimeMinutes: 254,
                    appBreakdown: [
                        AppUsage(appName: "YouTube", minutes: 83),
                        AppUsage(appName: "Instagram", minutes: 57),
                        AppUsage(appName: "Messages", minutes: 36)
                    ],
                    reactions: [],
                    isCurrentUser: true,
                    isTrackingPaused: false
                ),
                LeaderboardMember(
                    id: UUID(uuidString: "076152A9-EB8D-4DB2-9E56-43FBA1D470E2")!,
                    username: "Noor",
                    avatarSystemName: "person.crop.circle.fill",
                    totalScreenTimeMinutes: 309,
                    appBreakdown: [
                        AppUsage(appName: "FaceTime", minutes: 86),
                        AppUsage(appName: "Reddit", minutes: 76),
                        AppUsage(appName: "Maps", minutes: 33)
                    ],
                    reactions: [.caught],
                    isCurrentUser: false,
                    isTrackingPaused: false
                )
            ],
            isLocked: true,
            lockedAt: Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: Date())
        )
    ]
}
