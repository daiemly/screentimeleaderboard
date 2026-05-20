import Foundation

enum Reaction: String, CaseIterable, Identifiable {
    case cooked = "cooked"
    case wild = "wild"
    case respect = "respect"
    case caught = "caught"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .cooked:
            return "flame.fill"
        case .wild:
            return "bolt.fill"
        case .respect:
            return "hands.clap.fill"
        case .caught:
            return "eye.fill"
        }
    }

    var label: String {
        switch self {
        case .cooked:
            return "Cooked"
        case .wild:
            return "Wild"
        case .respect:
            return "Respect"
        case .caught:
            return "Caught"
        }
    }
}
