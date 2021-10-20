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
    }

    var openSection: Preferences.Section {
        Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
            VStack {
                Text("Open Permission Directories")
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
                        store.appendItems(panel.urls.map { FolderItem($0) })
                    }
                } label: { Label("Add Folder(s)", systemImage: "folder.badge.plus") }
            }
        } content: {
            List {
                ForEach(store.folderItems) { item in
                    HStack {
                        Image(systemName: "folder")
                        Text(item.path)
                    }
                }.onDelete { store.deleteItems(offsets: $0) }
            }.background(.background)
        }
    }

    var syncSection: Preferences.Section {
        Preferences.Section {
            VStack {
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
                        store.folderItems.append(contentsOf: panel.urls.map { FolderItem($0) })
                    }
                } label: { Label("Add Folder(s)", systemImage: "folder.badge.plus") }
            }
        } content: {
            Text("TODO")
                .onTapGesture {
                    let path = "/Users/kyle/Postman"
                    let config = NSWorkspace.OpenConfiguration()
                    config.promptsUserIfNeeded = true
                    NSWorkspace.shared.open([URL(fileURLWithPath: path)], withApplicationAt: URL(fileURLWithPath: "/Applications/Tower.app"), configuration: config) { _, _ in
                    }
                }
//            List {
//                ForEach(store.folderItems) { item in
//                    HStack {
//                        Image(systemName: "folder")
//                        Text(item.path)
//                    }
//                }
//            }
//            .background(.background)
        }
    }
}

struct FolderSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        FolderSettingTab(store: FolderItemStore())
    }
}
