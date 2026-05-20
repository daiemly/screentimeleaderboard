import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject private var store: LeaderboardStore
    @State private var expandedMemberIDs: Set<LeaderboardMember.ID> = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if let group = store.selectedGroup {
                        HeaderView(group: group)

                        VStack(spacing: 10) {
                            ForEach(Array(group.rankedMembers.enumerated()), id: \.element.id) { index, member in
                                LeaderboardRow(
                                    rank: index + 1,
                                    member: member,
                                    group: group,
                                    isExpanded: expandedMemberIDs.contains(member.id),
                                    onToggleExpanded: {
                                        toggleExpanded(member)
                                    },
                                    onReact: { reaction in
                                        store.addReaction(reaction, to: member, in: group)
                                    }
                                )
                            }
                        }

                        SyncFooter(lastSyncedAt: store.lastSyncedAt)
                    } else {
                        ContentUnavailableView("No Leaderboard", systemImage: "person.2.slash", description: Text("Create or join a group to start ranking."))
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await store.refreshCurrentUserUsage()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .accessibilityLabel("Refresh rankings")
                }
            }
        }
    }

    private func toggleExpanded(_ member: LeaderboardMember) {
        if expandedMemberIDs.contains(member.id) {
            expandedMemberIDs.remove(member.id)
        } else {
            expandedMemberIDs.insert(member.id)
        }
    }
}

private struct HeaderView: View {
    var group: LeaderboardGroup

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(.title.bold())
                    Text(group.isLocked ? "Rankings locked" : "Live rankings")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                LockBadge(isLocked: group.isLocked)
            }

            HStack(spacing: 12) {
                StatPill(title: "Winner", value: group.winner?.username ?? "-")
                StatPill(title: "Average", value: DurationFormatter.format(minutes: group.groupAverageMinutes))
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct LockBadge: View {
    var isLocked: Bool

    var body: some View {
        Label(isLocked ? "Locked" : "Live", systemImage: isLocked ? "lock.fill" : "dot.radiowaves.left.and.right")
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(isLocked ? Color.gray.opacity(0.14) : Color.green.opacity(0.14), in: Capsule())
            .foregroundStyle(isLocked ? .secondary : .green)
    }
}

private struct StatPill: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.gray.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct SyncFooter: View {
    var lastSyncedAt: Date

    var body: some View {
        Text("Updated \(lastSyncedAt.formatted(date: .omitted, time: .shortened))")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 4)
    }
}
