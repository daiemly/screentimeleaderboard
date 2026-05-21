import Combine
import Foundation

@MainActor
final class LeaderboardStore: ObservableObject {
    @Published var profile: UserProfile
    @Published var groups: [LeaderboardGroup]
    @Published var selectedGroupID: LeaderboardGroup.ID?
    @Published var hasCompletedOnboarding: Bool
    @Published var permissionStatus: ScreenTimePermissionStatus
    @Published var screenTimeConnectionDetail: String?
    @Published var lastSyncedAt: Date

    private let screenTimeProvider: ScreenTimeProviding

    init(screenTimeProvider: ScreenTimeProviding = ScreenTimeProvider()) {
        self.screenTimeProvider = screenTimeProvider
        self.profile = MockLeaderboardData.currentUser
        self.groups = MockLeaderboardData.groups
        self.selectedGroupID = MockLeaderboardData.groups.first?.id
        self.hasCompletedOnboarding = false
        self.permissionStatus = .notDetermined
        self.lastSyncedAt = Date()
    }

    var selectedGroup: LeaderboardGroup? {
        groups.first { $0.id == selectedGroupID }
    }

    func requestScreenTimePermission() async {
        permissionStatus = await screenTimeProvider.requestAuthorization()

        if ScreenTimeProvider.runsOnSimulator {
            screenTimeConnectionDetail =
                "Screen Time does not run in the Simulator. Using demo usage data so you can try the app. Run on a physical iPhone for the real permission prompt."
        } else if permissionStatus == .denied {
            screenTimeConnectionDetail =
                "Could not reach Screen Time (FamilyControlsAgent). Run on a physical iPhone, add the Family Controls capability in Xcode, and request the entitlement from Apple (see README)."
        } else {
            screenTimeConnectionDetail = nil
        }

        if permissionStatus == .approved {
            await refreshCurrentUserUsage()
        }
    }

    func finishOnboarding() {
        hasCompletedOnboarding = true
    }

    func selectGroup(_ group: LeaderboardGroup) {
        selectedGroupID = group.id
    }

    func createGroup(named name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let member = LeaderboardMember(
            id: profile.id,
            username: profile.username,
            avatarSystemName: profile.avatarSystemName,
            totalScreenTimeMinutes: 254,
            appBreakdown: [
                AppUsage(appName: "YouTube", minutes: 83),
                AppUsage(appName: "Instagram", minutes: 57),
                AppUsage(appName: "Messages", minutes: 36)
            ],
            reactions: [],
            isCurrentUser: true,
            isTrackingPaused: permissionStatus != .approved
        )

        let group = LeaderboardGroup(
            id: UUID(),
            name: trimmedName,
            inviteCode: "SCREEN-\(Int.random(in: 1000...9999))",
            members: [member],
            isLocked: false,
            lockedAt: nil
        )

        groups.insert(group, at: 0)
        selectedGroupID = group.id
    }

    func joinGroup(inviteCode: String) {
        let normalizedCode = inviteCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !normalizedCode.isEmpty else { return }

        createGroup(named: "Invite \(normalizedCode.suffix(4))")
        if let selectedGroupID,
           let index = groups.firstIndex(where: { $0.id == selectedGroupID }) {
            groups[index].inviteCode = normalizedCode
        }
    }

    func addReaction(_ reaction: Reaction, to member: LeaderboardMember, in group: LeaderboardGroup) {
        guard let groupIndex = groups.firstIndex(where: { $0.id == group.id }),
              let memberIndex = groups[groupIndex].members.firstIndex(where: { $0.id == member.id }) else {
            return
        }

        groups[groupIndex].members[memberIndex].reactions.append(reaction)
    }

    func lockSelectedGroupForRecap() {
        guard let selectedGroupID,
              let index = groups.firstIndex(where: { $0.id == selectedGroupID }) else {
            return
        }

        groups[index].isLocked = true
        groups[index].lockedAt = Date()
    }

    func refreshCurrentUserUsage() async {
        let usage = await screenTimeProvider.currentUsage()

        for groupIndex in groups.indices {
            guard let memberIndex = groups[groupIndex].members.firstIndex(where: { $0.id == profile.id }) else {
                continue
            }

            groups[groupIndex].members[memberIndex].totalScreenTimeMinutes = usage.totalMinutes
            groups[groupIndex].members[memberIndex].appBreakdown = usage.appBreakdown
            groups[groupIndex].members[memberIndex].isTrackingPaused = permissionStatus != .approved
        }

        lastSyncedAt = Date()
    }
}
