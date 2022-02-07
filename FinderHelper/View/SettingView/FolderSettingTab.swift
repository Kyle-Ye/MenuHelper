//
//  FolderSettingTab.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import MenuHeperExtension
import Preferences
import SwiftUI

struct FolderSettingTab: View {
    @ObservedObject var store: FolderItemStore

    var body: some View {
        Preferences.Container(contentWidth: 450) {
            openSection
            syncSection
        }
        .onAppear {
            channel.setup(store: store)
        }
    }

    var openSection: Preferences.Section {
        Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
            EmptyView()
        } content: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Open Permission Directories")
                    Spacer()
                    Button {
                        channel.send(name: "ChoosePermissionFolder", data: nil)
                    } label: { Label("Add Folder(s)", systemImage: "folder.badge.plus") }
                }
                VStack(alignment: .leading) {
                    Text("Directories which you have permission to open apps due to the sandbox limitation of macOS")
                    Text("Recommended folder is ~ (home directory)")
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
            }
        }
    }

    var syncSection: Preferences.Section {
        Preferences.Section {
            EmptyView()
        } content: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Sync Permission Directories")
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
                    Text("But *contextual menu* will only show in sync permission directories")
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
