# Screen Time Leaderboard

Native SwiftUI MVP for the PRD in `Screentime Leaderboard.pdf`.

The app implements the beta product loop with local mock data:

- Screen Time permission onboarding
- Username/avatar profile shape
- Multiple leaderboard groups
- Create and join flows with invite codes
- Daily rankings where the lowest screen time ranks highest
- Expandable rows with app usage breakdowns
- Lightweight reactions
- Tracking paused state for missing data
- Nightly recap view with winner, highest usage, most used app, and group average

## Open

Open `ScreenTimeLeaderboard.xcodeproj` in Xcode.

- **Simulator:** UI and mock leaderboard data work, but Apple's Screen Time APIs do not. "Connect Screen Time" uses demo data and shows a note in onboarding.
- **Physical iPhone:** Required for the real Screen Time permission sheet and `FamilyControls` agent.

## Screen Time Integration

`ScreenTimeProvider` contains the integration boundary for Apple's `FamilyControls` and `DeviceActivity` APIs. The UI currently uses mock-shaped data so the product can be reviewed without Apple entitlement setup.

To connect real data:

1. Request the [Family Controls entitlement](https://developer.apple.com/contact/request/family-controls-distribution) from Apple.
2. In Xcode, add the **Family Controls** capability to the app target (updates `ScreenTimeLeaderboard.entitlements`).
3. Run on a **physical device** signed with a profile that includes that entitlement.
4. Add a Device Activity report extension.
5. Replace the placeholder snapshot in `FamilyControlsScreenTimeProvider.currentUsage()`.
6. Add backend sync for group leaderboards and invite links.
