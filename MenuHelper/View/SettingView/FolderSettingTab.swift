//
//  FolderSettingTab.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct FolderSettingTab: View {
    var store: FolderItemStore
    @State private var isExpanded = false

    var body: some View {
        Form {
            openSection
            syncSection
        }
        .formStyle(.grouped)
        .onAppear {
            Task {
                await channel.setup(store: store)
            }
        }
    }

    @MainActor
    var openSection: some View {
        Section {
            HStack {
                Button {
                    channel.send(name: "ChoosePermissionFolder", data: nil)
                } label: { Label("Add Folders", systemImage: "folder.badge.plus") }
                Button {
                    store.deleteAllBookmarkItems()
                } label: { Label("Remove All", systemImage: "folder.badge.minus") }
            }
            List {
                ForEach(store.bookmarkItems) { item in
                    HStack {
                        Image(systemName: "folder")
                        Text(item.path)
                    }
                }
                .onDelete { store.deleteBookmarkItems(offsets: $0) }
            }
        } header: {
            Text("User Seleted Directories")
        } footer: {
            VStack {
                HStack {
                    (
                        Text("Directories where you have permission for *application menu items* to open apps and *new file action menu* to create file")
                            + Text(verbatim: "\n")
                            + Text("Recommended folder is \("/Users/\(NSUserName())") (current user's 🏠 directory)")
                    )
                    .foregroundColor(.secondary)
                    .font(.caption)
                    Spacer()
                }
                DisclosureGroup("Permission description", isExpanded: $isExpanded) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Both the main app and the extension are sandboxed binary.")
                            Text("The main app need the following user-selected files permission:")
                            Text("- Read permission: Add Finder Sync Directories")
                            Text("The extension need the following user-selected files permissions:")
                            Text("- Read permission: Open file/folder with custom Application")
                            Text("- Write permission: Add New File in Finder")
                        }
                        Spacer()
                    }
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
    }

    @MainActor
    var syncSection: some View {
        Section {
            HStack {
                Button {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = true
                    panel.allowedContentTypes = [.folder]
                    panel.canChooseDirectories = true
                    if let pw = getpwuid(getuid()), let home = pw.pointee.pw_dir {
                        let path = FileManager.default.string(withFileSystemRepresentation: home, length: strlen(home))
                        panel.directoryURL = URL(fileURLWithPath: path)
                    } else {
                        panel.directoryURL = URL(fileURLWithPath: "/Users")
                    }
                    if panel.runModal() == .OK {
                        store.appendItems(panel.urls.map { SyncFolderItem($0) })
                    }
                } label: { Label("Add Folders", systemImage: "folder.badge.plus") }
                Button {
                    store.deleteAllSyncItems()
                } label: { Label("Remove All", systemImage: "folder.badge.minus") }
            }
            List {
                ForEach(store.syncItems) { item in
                    HStack {
                        Image(systemName: "folder")
                        Text(item.path)
                    }
                }
                .onDelete { store.deleteSyncItems(offsets: $0) }
                .onInsert(of: [.fileURL, .folder]) { index, providers in
                    Task {
                        var items = [SyncFolderItem]()
                        for provider in providers {
                            if let coding = try? await provider.loadItem(forTypeIdentifier: "public.file-url", options: nil),
                               let data = coding as? Data,
                               let urlString = String(data: data, encoding: .utf8),
                               let url = URL(string: urlString) {
                                let item = SyncFolderItem(url)
                                items.append(item)
                            }
                        }
                        store.insertItems(items, at: index)
                    }
                }
            }
        } header: {
            Text("Finder Sync Directories")
        } footer: {
            HStack {
                (
                    Text("Toolbar item menu will show in every directory")
                        + Text(verbatim: "\n")
                        + Text("But *contextual menu* will only show in Finder Sync directories")
                )
                .foregroundColor(.secondary)
                .font(.caption)
                Spacer()
            }
        }
    }
}

#Preview {
    FolderSettingTab(store: FolderItemStore())
}
