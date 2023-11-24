//
//  MenuSettingTab.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import Settings
import enum Settings.Settings
import SwiftUI

@Observable
class MenuSettingTabState {
    var showSubMenuForApplication: Bool {
        get {
            access(keyPath: \.showSubMenuForApplication)
            return UserDefaults.group.bool(forKey: Key.showSubMenuForApplication)
        }
        set {
            withMutation(keyPath: \.showSubMenuForApplication) {
                UserDefaults.group.setValue(newValue, forKey: Key.showSubMenuForApplication)
            }
        }
    }
    
    var showSubMenuForAction: Bool {
        get {
            access(keyPath: \.showSubMenuForAction)
            return UserDefaults.group.bool(forKey: Key.showSubMenuForAction)
        }
        set {
            withMutation(keyPath: \.showSubMenuForAction) {
                UserDefaults.group.setValue(newValue, forKey: Key.showSubMenuForAction)
            }
        }
    }
}

struct MenuSettingTab: View {
    var store: MenuItemStore
    @State private var isDrogTargeted = false
    @State private var appMenuItemEdited = false
    @State private var model = MenuSettingTabState()

    var body: some View {
        Form {
            appItemSection
            actionItemSection
        }
        .controlSize(.large)
        .formStyle(.grouped)
        .frame(width: 520)
    }

    @MainActor
    var appItemSection: some View {
        Section {
            Toggle(isOn: $model.showSubMenuForApplication) {
                Text("Show as submenu")
            }
            List {
                ForEach(store.appItems) { item in
                    AppMenuItemView(item: item)
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
            Text("Application Menu Items")
        } footer: {
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
    }

    @MainActor
    var actionItemSection: some View {
        Section {
            Toggle(isOn: $model.showSubMenuForAction) {
                Text("Show as submenu")
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
            .onMove { store.moveActionItems(from: $0, to: $1) }
                
        } header: {
            Text("Action Menu Items")
        } footer: {
            Link("Suggest more action menus here", destination: URL(string: "https://github.com/Kyle-Ye/MenuHelperApp/issues/new/choose")!)
        }
    }
}

#Preview {
    MenuSettingTab(store: MenuItemStore())
        .background(.background)
}
