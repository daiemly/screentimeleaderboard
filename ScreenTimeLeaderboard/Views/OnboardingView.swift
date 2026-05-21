import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var store: LeaderboardStore
    @State private var groupName = "Close Friends"
    @State private var isRequestingPermission = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 28) {
                Spacer(minLength: 12)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Screen Time Leaderboard")
                        .font(.system(size: 40, weight: .bold))
                        .lineLimit(3)

                    Text("Compete with friends using real daily screen time. Lowest usage wins. Rankings reset every morning.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(spacing: 12) {
                    OnboardingStepRow(number: 1, title: "Connect Screen Time", subtitle: store.permissionStatus.title)
                    OnboardingStepRow(number: 2, title: "Create a leaderboard", subtitle: "Invite friends with a link")
                    OnboardingStepRow(number: 3, title: "Check live rankings", subtitle: "React when someone is cooked")

                    if let detail = store.screenTimeConnectionDetail {
                        Text(detail)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("First leaderboard")
                        .font(.headline)

                    TextField("Group name", text: $groupName)
                        .textInputAutocapitalization(.words)
                        .padding(14)
                        .background(.gray.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
                }

                Spacer(minLength: 12)

                VStack(spacing: 10) {
                    Button {
                        Task {
                            isRequestingPermission = true
                            await store.requestScreenTimePermission()
                            isRequestingPermission = false
                        }
                    } label: {
                        Label(isRequestingPermission ? "Connecting" : "Connect Screen Time", systemImage: "hourglass")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(isRequestingPermission)

                    Button {
                        store.createGroup(named: groupName)
                        store.finishOnboarding()
                    } label: {
                        Label("Enter Leaderboard", systemImage: "arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                }
            }
            .padding(24)
            .navigationBarHidden(true)
        }
    }
}

private struct OnboardingStepRow: View {
    var number: Int
    var title: String
    var subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            Text("\(number)")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(.black, in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
