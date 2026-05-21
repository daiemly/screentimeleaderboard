import Foundation

enum ScreenTimePermissionStatus {
    case notDetermined
    case approved
    case denied

    var title: String {
        switch self {
        case .notDetermined:
            return "Not connected"
        case .approved:
            return "Tracking active"
        case .denied:
            return "Tracking paused"
        }
    }
}

struct ScreenTimeSnapshot {
    var totalMinutes: Int
    var appBreakdown: [AppUsage]
}

protocol ScreenTimeProviding {
    func requestAuthorization() async -> ScreenTimePermissionStatus
    func currentUsage() async -> ScreenTimeSnapshot
}

struct ScreenTimeProvider: ScreenTimeProviding {
    static var runsOnSimulator: Bool {
        #if targetEnvironment(simulator)
        true
        #else
        false
        #endif
    }

    func requestAuthorization() async -> ScreenTimePermissionStatus {
        #if targetEnvironment(simulator)
        return .approved
        #elseif canImport(FamilyControls)
        return await FamilyControlsScreenTimeProvider().requestAuthorization()
        #else
        return .approved
        #endif
    }

    func currentUsage() async -> ScreenTimeSnapshot {
        #if targetEnvironment(simulator)
        return Self.demoSnapshot
        #elseif canImport(FamilyControls)
        return await FamilyControlsScreenTimeProvider().currentUsage()
        #else
        return Self.demoSnapshot
        #endif
    }

    static let demoSnapshot = ScreenTimeSnapshot(
        totalMinutes: 254,
        appBreakdown: [
            AppUsage(appName: "YouTube", minutes: 83),
            AppUsage(appName: "Instagram", minutes: 57),
            AppUsage(appName: "Messages", minutes: 36),
            AppUsage(appName: "Safari", minutes: 31)
        ]
    )
}

#if canImport(FamilyControls)
import FamilyControls

struct FamilyControlsScreenTimeProvider: ScreenTimeProviding {
    func requestAuthorization() async -> ScreenTimePermissionStatus {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            return .approved
        } catch {
            return .denied
        }
    }

    func currentUsage() async -> ScreenTimeSnapshot {
        // DeviceActivity reports are delivered through an extension. The app keeps
        // using mock-shaped data until that extension and backend sync are added.
        return ScreenTimeProvider.demoSnapshot
    }
}
#endif
