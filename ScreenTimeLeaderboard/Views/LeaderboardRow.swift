import SwiftUI

struct LeaderboardRow: View {
    var rank: Int
    var member: LeaderboardMember
    var group: LeaderboardGroup
    var isExpanded: Bool
    var onToggleExpanded: () -> Void
    var onReact: (Reaction) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggleExpanded) {
                HStack(spacing: 12) {
                    Text("\(rank)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(width: 28)

                    Image(systemName: member.avatarSystemName)
                        .font(.system(size: 34))
                        .foregroundStyle(member.isTrackingPaused ? .gray : .black)
                        .frame(width: 40, height: 40)

                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 6) {
                            Text(member.username)
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .lineLimit(1)

                            if member.isCurrentUser {
                                Text("You")
                                    .font(.caption2.weight(.bold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(Color.gray.opacity(0.14), in: Capsule())
                            }
                        }

                        if member.isTrackingPaused {
                            Label("Tracking paused", systemImage: "pause.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else if let topApp = member.topApp {
                            Text("\(topApp.appName) \(topApp.formattedDuration)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }

                    Spacer(minLength: 8)

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(member.isTrackingPaused ? "-" : member.formattedScreenTime)
                            .font(.headline)
                            .foregroundStyle(member.isTrackingPaused ? .secondary : .primary)

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                }
                .contentShape(Rectangle())
                .padding(14)
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 14) {
                    if !member.appBreakdown.isEmpty {
                        AppBreakdownView(apps: member.appBreakdown)
                    }

                    ReactionBar(
                        reactions: member.reactions,
                        onReact: onReact
                    )
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(.white, in: RoundedRectangle(cornerRadius: 8))
        .animation(.snappy, value: isExpanded)
    }
}

private struct AppBreakdownView: View {
    var apps: [AppUsage]

    private var maxMinutes: Int {
        apps.map(\.minutes).max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("App usage")
                .font(.subheadline.weight(.semibold))

            ForEach(apps) { app in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(app.appName)
                            .font(.subheadline)
                        Spacer()
                        Text(app.formattedDuration)
                            .font(.subheadline.weight(.medium))
                    }

                    GeometryReader { proxy in
                        let width = proxy.size.width * CGFloat(app.minutes) / CGFloat(maxMinutes)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black.opacity(0.82))
                            .frame(width: max(width, 6), height: 7)
                    }
                    .frame(height: 7)
                }
            }
        }
        .padding(12)
        .background(.gray.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct ReactionBar: View {
    var reactions: [Reaction]
    var onReact: (Reaction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Reactions")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(reactions.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                ForEach(Reaction.allCases) { reaction in
                    Button {
                        onReact(reaction)
                    } label: {
                        Image(systemName: reaction.symbol)
                            .font(.subheadline.weight(.bold))
                            .frame(width: 38, height: 34)
                    }
                    .buttonStyle(.bordered)
                    .tint(.black)
                    .accessibilityLabel(reaction.label)
                }
            }
        }
    }
}
