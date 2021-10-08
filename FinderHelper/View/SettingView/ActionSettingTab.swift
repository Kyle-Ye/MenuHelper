//
//  ActionSettingTab.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import Preferences
import SwiftUI

struct ActionSettingTab: View {
    @AppStorage("SHOW_TOOLBAR_MENU", store: .standard)
    private var showToolbarMenu = true
    @AppStorage("SHOW_CONTEXTUAL_MENU", store: .standard)
    private var showContextualMenu = true

    @ObservedObject var store: AppMenuItemStore
    @State private var editItem = false
    @State private var isDrogTargeted = false

    var body: some View {
        Preferences.Container(contentWidth: 450.0) {
            Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
                Text("Locations:")
            } content: {
                Toggle(isOn: $showContextualMenu) {
                    Text("Show in contextual menu")
                }
                Toggle(isOn: $showToolbarMenu) {
                    Text("Show in toolbar menu")
                }
                // Add a reload button to kill finder process to reload the extension
            }
            Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
                Text("Actions")
            } content: {
                Group {
                    if isDrogTargeted {
                        Text("Drog Here")
                    } else {
                        List($store.items) { $item in
                            HStack {
                                Toggle(isOn: $item.enabled) { EmptyView() }.toggleStyle(.checkmark)
                                Image(nsImage: item.icon)
                                Text(item.name)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    editItem = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }

                                Button(role: .destructive) {
                                    guard let index = store.items.firstIndex(of: item) else { return }
                                    store.items.remove(at: index)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            // BUG TOBEFIX
                            .sheet(isPresented: $editItem) {
                                editItem = false
                            } content: {
                                AppMenuItemEditor(item: $item)
                            }
                        }
                    }
                }
                .background(.background)
                .onDrop(of: [.application], isTargeted: $isDrogTargeted) { _, _ in
                    // TODO: - FIX ME
                    true
                }
            }
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
                            panel.urls.forEach { url in
                                store.items.append(AppMenuItem(appURL: url))
                            }
                        }
                    } label: {
                        Image(systemName: "plus.app")
                        Text("Add Application")
                    }
                    Button {} label: {
                        Text("Add Copy Path")
                    }
                }
            }
        }
    }
}

struct ActionSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        ActionSettingTab(store: AppMenuItemStore())
            .background(.background)
            .preferredColorScheme(.light)
        ActionSettingTab(store: AppMenuItemStore())
            .background(.background)
            .preferredColorScheme(.dark)
    }
}
