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
            appItemSection
            actionItemSection
        }
    }

    var appItemSection: Preferences.Section {
        Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
            VStack {
                Text("Application Items")
                Spacer()
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
            }
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
                .onDelete { store.deleteAppItems(offsets: $0) }
                .onMove { store.moveAppItems(from: $0, to: $1) }
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
            }
            .background(.background)
        }
    }

    var actionItemSection: Preferences.Section {
        Preferences.Section {
            VStack {
                Text("Action Items")
                Spacer()
                Button {
                    store.appendItem(ActionMenuItem.copyPath)
                } label: {
                    Text("Add Copy Path")
                }
            }
        } content: {
            List {
                ForEach(store.actionItems) { item in
                    HStack {
                        Checkmark(isOn: item.enabled)
                        Image(nsImage: item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                        Text(item.name)
                    }.onTapGesture {
                        store.toggleItem(item)
                    }
                }
                .onDelete { store.deleteActionItems(offsets: $0) }
                .onMove { store.moveActionItems(from: $0, to: $1) }
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
