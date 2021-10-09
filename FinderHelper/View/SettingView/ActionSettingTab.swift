//
//  ActionSettingTab.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import Preferences
import SwiftUI

struct ActionSettingTab: View {
    @ObservedObject var store: MenuItemStore
    @State private var isDrogTargeted = false

    var body: some View {
        Preferences.Container(contentWidth: 450.0) {
            itemsSection
            buttonSection
        }
    }

    var itemsSection: Preferences.Section {
        Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
            Text("Actions")
        } content: {
            List {
                ForEach(store.appItems) { item in
                    HStack {
                        Checkmark(isOn: item.enabled)
                        Image(nsImage: item.icon)
                        Text(item.name)
                    }.onTapGesture {
                        store.toggleItem(item)
                    }
                }
                .onDelete(perform: store.deleteAppItems(offsets:))
                .onMove(perform: store.moveAppItems(from:to:))
                .onInsert(of: [.fileURL, .folder]) { index, providers in
                    Task {
                        var items = [AppMenuItem]()
                        for provider in providers {
                            if let coding = try? await provider.loadItem(forTypeIdentifier: "public.file-url", options: nil),
                               let data = coding as? Data,
                               let urlString = String(data: data, encoding: .utf8),
                               let url = URL(string: urlString) {
                                let item = AppMenuItem(appURL: url)
                                items.append(item)
                            }
                        }
                        store.insertItems(items, at: index)
                    }
                }
                Divider()
                ForEach(store.actionItems) { item in
                    HStack {
                        Checkmark(isOn: item.enabled)
                        Text(item.name)
                    }.onTapGesture {
                        store.toggleItem(item)
                    }
                }
                .onDelete(perform: store.deleteActionItems(offsets:))
            }
            .background(.background)
        }
    }

    var buttonSection: Preferences.Section {
        Preferences.Section {
            EmptyView()
        } content: {
            HStack {
                Button {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = true
                    panel.allowedContentTypes = [.application]
                    panel.canChooseDirectories = false
                    panel.directoryURL = URL(fileURLWithPath: "/Applications/")
                    if panel.runModal() == .OK {
                        let items = panel.urls.map { AppMenuItem(appURL: $0) }
                        store.appendItems(items)
                    }
                } label: {
                    Image(systemName: "plus.app")
                    Text("Add Application")
                }
                Button {
                    store.appendItem(ActionMenuItem.copyPath)
                } label: {
                    Text("Add Copy Path")
                }
            }
        }
    }
}

struct ActionSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        ActionSettingTab(store: MenuItemStore())
            .background(.background)
            .preferredColorScheme(.light)
        ActionSettingTab(store: MenuItemStore())
            .background(.background)
            .preferredColorScheme(.dark)
    }
}
