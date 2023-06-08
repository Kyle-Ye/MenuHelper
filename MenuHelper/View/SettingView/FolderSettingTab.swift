//
//  FolderSettingTab.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import MenuHelperExtension
import Preferences
import SwiftUI

struct FolderSettingTab: View {
    @ObservedObject var store: FolderItemStore
    @State private var isExpanded = false

    var body: some View {
        Preferences.Container(contentWidth: 500) {
            openSection
            syncSection
        }
        .onAppear {
            Task {
                await channel.setup(store: store)
            }
        }
    }

    var openSection: Preferences.Section {
        Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
            EmptyView()
        } content: {
            VStack(alignment: .leading) {
                HStack {
                    Text("User Seleted Directories")
                    Spacer()
                    Button {
                        channel.send(name: "ChoosePermissionFolder", data: nil)
                    } label: { Label("Add Folder(s)", systemImage: "folder.badge.plus") }
                }
                VStack(alignment: .leading) {
                    Text("Directories where you have permission for *application menu items* to open apps and *new file action menu* to create file")
                    Text("Recommended folder is \("/Users/\(NSUserName())") (current user's 🏠 directory)")
                }
                .foregroundColor(.secondary)
                .font(.caption)
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

    var syncSection: Preferences.Section {
        Preferences.Section {
            EmptyView()
        } content: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Finder Sync Directories")
                    Spacer()
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
                    } label: { Label("Add Folder(s)", systemImage: "folder.badge.plus") }
                }
                VStack(alignment: .leading) {
                    Text("Toolbar item menu will show in every directory")
                    Text("But *contextual menu* will only show in Finder Sync directories")
                }
                .foregroundColor(.secondary)
                .font(.caption)
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
