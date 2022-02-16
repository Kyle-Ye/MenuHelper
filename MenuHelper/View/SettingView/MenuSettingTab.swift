//
//  MenuSettingTab.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import Preferences
import SwiftUI

struct MenuSettingTab: View {
    @ObservedObject var store: MenuItemStore
    @State private var isDrogTargeted = false

    var body: some View {
        Preferences.Container(contentWidth: 520) {
            appItemSection
            actionItemSection
        }
    }

    var appItemSection: Preferences.Section {
        Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
            EmptyView()
        } content: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Application Menu Items")
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
                        Label("Add Application(s)", systemImage: "plus.app")
                    }
                }
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
    }

    var actionItemSection: Preferences.Section {
        Preferences.Section {
            EmptyView()
        } content: {
            VStack(alignment: .leading) {
                Text("Action Menu Items")
                List {
                    ForEach(ActionMenuItem.all.filter{ !store.actionItems.contains($0) }) { item in
                        Button {
                            store.appendItem(item)
                        } label: {
                            Label("Add \(item.name)", systemImage: "plus.app")
                        }
                    }
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
}

struct ActionSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        MenuSettingTab(store: MenuItemStore())
            .background(.background)
            .preferredColorScheme(.light)
        MenuSettingTab(store: MenuItemStore())
            .background(.background)
            .preferredColorScheme(.dark)
    }
}
