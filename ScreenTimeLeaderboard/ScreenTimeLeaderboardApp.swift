import SwiftUI

@main
struct ScreenTimeLeaderboardApp: App {
    @StateObject private var store = LeaderboardStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
