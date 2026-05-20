import SwiftUI

struct RecapView: View {
    @EnvironmentObject private var store: LeaderboardStore

    var body: some View {
        NavigationStack {
            ScrollView {
                if let group = store.selectedGroup {
                    VStack(alignment: .leading, spacing: 16) {
                        RecapHeader(group: group)

                        VStack(spacing: 10) {
                            RecapStatRow(
                                icon: "crown.fill",
                                title: "Winner",
                                value: group.winner?.username ?? "-"
                            )

                            RecapStatRow(
                                icon: "arrow.up.right",
                                title: "Highest screen time",
                                value: highestScreenTimeText(for: group)
                            )

                            RecapStatRow(
                                icon: "apps.iphone",
                                title: "Most used app",
                                value: mostUsedAppText(for: group)
                            )

                            RecapStatRow(
                                icon: "person.3.fill",
                                title: "Group average",
                                value: DurationFormatter.format(minutes: group.groupAverageMinutes)
                            )
                        }

                        Button {
                            store.lockSelectedGroupForRecap()
                        } label: {
                            Label("Generate Nightly Recap", systemImage: "moon.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        .disabled(group.isLocked)
                    }
                    .padding(16)
                } else {
                    ContentUnavailableView("No Recap", systemImage: "moon.stars", description: Text("Select a group to view the nightly recap."))
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Recap")
        }
    }

    private func highestScreenTimeText(for group: LeaderboardGroup) -> String {
        guard let member = group.highestScreenTimeMember else { return "-" }
        return "\(member.username), \(member.formattedScreenTime)"
    }

    private func mostUsedAppText(for group: LeaderboardGroup) -> String {
        guard let app = group.mostUsedApp else { return "-" }
        return "\(app.appName), \(app.formattedDuration)"
    }
}

private struct RecapHeader: View {
    var group: LeaderboardGroup

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(group.name)
                .font(.title.bold())
            Text(group.isLocked ? "Final standings are locked for tonight." : "Recap is ready at the end of the day.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct RecapStatRow: View {
    var icon: String
    var title: String
    var value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .frame(width: 34, height: 34)
                .background(.gray.opacity(0.1), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }

            Spacer()
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
    }
}
