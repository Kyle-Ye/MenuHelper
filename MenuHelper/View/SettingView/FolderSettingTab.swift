//
//  FolderSettingTab.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import MenuHelperExtension
import enum Settings.Settings
import SwiftUI

struct FolderSettingTab: View {
    var store: FolderItemStore
    @State private var isExpanded = false

    var body: some View {
        Settings.Container(contentWidth: 500) {
            openSection
            syncSection
        }
        .onAppear {
            Task {
                await channel.setup(store: store)
            }
        }
    }

    @MainActor
    var openSection: Settings.Section {
        Settings.Section(bottomDivider: true, verticalAlignment: .top) {
            EmptyView()
        } content: {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("User Seleted Directories")
                        (
                            Text("Directories where you have permission for *application menu items* to open apps and *new file action menu* to create file")
                                + Text(verbatim: "\n")
                                + Text("Recommended folder is \("/Users/\(NSUserName())") (current user's 🏠 directory)")
                        )
                        .foregroundColor(.secondary)
                        .font(.caption)
                    }
                    Spacer()
                    VStack {
                        Button {
                            channel.send(name: "ChoosePermissionFolder", data: nil)
                        } label: { Label("Add Folders", systemImage: "folder.badge.plus") }
                        Button {
                            store.deleteAllBookmarkItems()
                        } label: { Label("Remove All", systemImage: "folder.badge.minus") }
                    }
                }
                List {
                    ForEach(store.bookmarkItems) { item in
                        HStack {
                            Image(systemName: "folder")
                            Text(item.path)
                        }
                    }.onDelete { store.deleteBookmarkItems(offsets: $0) }
                }
                .background(.background)
                DisclosureGroup("Permission description", isExpanded: $isExpanded) {
                    VStack(alignment: .leading) {
                        Text("The application itself does not require user seleted folder permission")
                        Text("but the FinderSync extension need it for the following reason:")
                        Text("- Read permission: Open with custom application")
                        Text("- Write permission: New file in folder")
                        Text(verbatim: "\n")
                        Text("All permission are only valid in the Finder Sync extension which runs on Finder.app")
                        Text("The persmission will not be shared to the main app")
                    }
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
    }

    @MainActor
    var syncSection: Settings.Section {
        Settings.Section {
            EmptyView()
        } content: {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Finder Sync Directories")
                        (
                            Text("Toolbar item menu will show in every directory")
                                + Text(verbatim: "\n")
                                + Text("But *contextual menu* will only show in Finder Sync directories")
                        )
                        .foregroundColor(.secondary)
                        .font(.caption)
                    }
                    Spacer()
                    VStack {
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
                .background(.background)
            }
        }
    }
}

struct FolderSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        FolderSettingTab(store: FolderItemStore())
    }
}
