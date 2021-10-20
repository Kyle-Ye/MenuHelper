//
//  MenuItemStore.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import OrderedCollections
import SwiftUI

class MenuItemStore: ObservableObject {
    @Published private(set) var appItems: [AppMenuItem] = []
    @Published private(set) var actionItems: [ActionMenuItem] = []

    // MARK: - Init

    init() {
        try? load()
    }

    // MARK: - Toggle Item

    @MainActor func toggleItem<MenuItemType: MenuItem>(_ item: MenuItemType) {
        if let app = item as? AppMenuItem,
           let index = appItems.firstIndex(of: app) {
            appItems[index].enabled.toggle()
        }

        if let action = item as? ActionMenuItem,
           let index = actionItems.firstIndex(of: action) {
            actionItems[index].enabled.toggle()
        }

        try? save()
    }

    // MARK: - Append Item

    @MainActor func appendItems<MenuItemType: MenuItem>(_ items: [MenuItemType]) {
        if let apps = items as? [AppMenuItem] {
            appItems.append(contentsOf: apps.filter { !appItems.contains($0) })
        }

        if let actions = items as? [ActionMenuItem] {
            actionItems.append(contentsOf: actions.filter { !actionItems.contains($0) })
        }
        try? save()
    }

    @MainActor func insertItems<MenuItemType: MenuItem>(_ items: [MenuItemType], at index: Int) {
        if let apps = items as? [AppMenuItem] {
            appItems.insert(contentsOf: apps.filter { !appItems.contains($0) }, at: index)
        }

        if let actions = items as? [ActionMenuItem] {
            actionItems.insert(contentsOf: actions.filter { !actionItems.contains($0) }, at: index)
        }
        try? save()
    }

    @MainActor func appendItem<MenuItemType: MenuItem>(_ item: MenuItemType) {
        if let app = item as? AppMenuItem {
            if !appItems.contains(app) {
                appItems.append(app)
            }
        }

        if let action = item as? ActionMenuItem {
            if !actionItems.contains(action) {
                actionItems.append(action)
            }
        }
        try? save()
    }

    // MARK: - Delete Items

    @MainActor func deleteAppItems(offsets: IndexSet) {
        withAnimation {
            appItems.remove(atOffsets: offsets)
        }
        try? save()
    }

    @MainActor func deleteActionItems(offsets: IndexSet) {
        withAnimation {
            actionItems.remove(atOffsets: offsets)
        }
        try? save()
    }

    // MARK: - Move Items

    @MainActor func moveAppItems(from source: IndexSet, to destination: Int) {
        withAnimation {
            appItems.move(fromOffsets: source, toOffset: destination)
        }
        try? save()
    }

    @MainActor func moveActionItems(from source: IndexSet, to destination: Int) {
        withAnimation {
            actionItems.move(fromOffsets: source, toOffset: destination)
        }
        try? save()
    }

    // MARK: - Get Item

    func getAppItem(name: String) -> AppMenuItem? {
        appItems.first { name.contains($0.name) }
    }

    func getActionItem(name: String) -> ActionMenuItem? {
        actionItems.first { $0.name == name }
    }

    // MARK: - UserDefaults

    func load() throws {
        if let appItemsData = UserDefaults.group.data(forKey: "APP_ITEMS"),
           let actionItemsData = UserDefaults.group.data(forKey: "ACTION_ITEMS") {
            let decoder = PropertyListDecoder()
            var appItems = try decoder.decode([AppMenuItem].self, from: appItemsData)
            let actionItems = try decoder.decode([ActionMenuItem].self, from: actionItemsData)
            if appItems.isEmpty {
                appItems = AppMenuItem.defaultApps
            }
            DispatchQueue.main.async {
                self.appItems = appItems
                self.actionItems = actionItems
            }
        }
    }

    private func save() throws {
        let encoder = PropertyListEncoder()
        let appItemsData = try encoder.encode(OrderedSet(appItems))
        let actionItemsData = try encoder.encode(OrderedSet(actionItems))
        UserDefaults.group.set(appItemsData, forKey: "APP_ITEMS")
        UserDefaults.group.set(actionItemsData, forKey: "ACTION_ITEMS")
        UserDefaults.group.set(true, forKey: "MENU_ITEM_STORE_NEED_UPDATE")
    }
}

extension UserDefaults {
    static var group: UserDefaults {
        UserDefaults(suiteName: "group.top.kyleye.FinderHelper")!
    }
}
