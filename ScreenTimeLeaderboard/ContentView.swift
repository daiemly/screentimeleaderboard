import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: LeaderboardStore

    var body: some View {
        Group {
            if store.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
        .environmentObject(LeaderboardStore())
}
