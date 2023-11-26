//
//  MenuSettingTab.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct MenuSettingTab: View {
    @Bindable var store: MenuItemStore
    @State private var isDrogTargeted = false
    @State private var appMenuItemEdited = false

    @AppStorage(Key.showSubMenuForApplication)
    private var showSubMenuForApplication = false

    @AppStorage(Key.showSubMenuForAction)
    private var showSubMenuForAction = false

    var body: some View {
        Form {
            appItemSection
            actionItemSection
        }
        .controlSize(.large)
        .formStyle(.grouped)
    }

    @MainActor
    var appItemSection: some View {
        Section {
            Toggle(isOn: $showSubMenuForApplication) {
                Text("Show as submenu")
            }
            List {
                ForEach($store.appItems) { $item in
                    AppMenuItemView(item: $item)
                        .environment(store)
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
                .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
        } header: {
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
                    Label("Add Application Menu Items(s)", systemImage: "plus.app")
                        .font(.body)
                }
            }
        }
    }

    @MainActor
    var actionItemSection: some View {
        Section {
            Toggle(isOn: $showSubMenuForAction) {
                Text("Show as submenu")
            }
            ForEach($store.actionItems) { $item in
                HStack {
                    Image(nsImage: item.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                    Toggle(isOn: $item.enabled) {
                        Text(item.name)
                    }.toggleStyle(.button)
                }
            }
            .onMove { store.moveActionItems(from: $0, to: $1) }
        } header: {
            HStack {
                Text("Action Menu Items")
                Spacer()
                Button {
                    store.resetActionItems()
                } label: {
                    Label("Reset Action Menu Items", systemImage: "arrow.triangle.2.circlepath")
                        .font(.body)
                }
            }
        } footer: {
            Link("Suggest more action menus here", destination: URL(string: "https://github.com/Kyle-Ye/MenuHelperApp/issues/new/choose")!)
        }
    }
}

#Preview {
    MenuSettingTab(store: MenuItemStore())
        .background(.background)
}
