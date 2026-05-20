import Foundation

struct UserProfile: Identifiable, Hashable {
    let id: UUID
    var username: String
    var avatarSystemName: String
}
