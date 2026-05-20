import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "list.number")
                }

            GroupsView()
                .tabItem {
                    Label("Groups", systemImage: "person.2.fill")
                }

            RecapView()
                .tabItem {
                    Label("Recap", systemImage: "moon.stars.fill")
                }
        }
        .tint(.black)
    }
}
