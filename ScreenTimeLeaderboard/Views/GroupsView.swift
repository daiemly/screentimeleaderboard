import SwiftUI

struct GroupsView: View {
    @EnvironmentObject private var store: LeaderboardStore
    @State private var newGroupName = ""
    @State private var inviteCode = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Your groups") {
                    ForEach(store.groups) { group in
                        Button {
                            store.selectGroup(group)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(group.name)
                                        .font(.headline)
                                    Text("\(group.members.count) members")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if store.selectedGroupID == group.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }

                Section("Create") {
                    HStack {
                        TextField("Leaderboard name", text: $newGroupName)
                        Button {
                            store.createGroup(named: newGroupName)
                            newGroupName = ""
                        } label: {
                            Image(systemName: "plus")
                        }
                        .disabled(newGroupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }

                Section("Join") {
                    HStack {
                        TextField("Invite code", text: $inviteCode)
                            .textInputAutocapitalization(.characters)
                        Button {
                            store.joinGroup(inviteCode: inviteCode)
                            inviteCode = ""
                        } label: {
                            Image(systemName: "link")
                        }
                        .disabled(inviteCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }

                if let group = store.selectedGroup {
                    Section("Invite link") {
                        ShareLink(item: "https://screentimeleaderboard.app/join/\(group.inviteCode)") {
                            Label(group.inviteCode, systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
            .navigationTitle("Groups")
        }
    }
}
