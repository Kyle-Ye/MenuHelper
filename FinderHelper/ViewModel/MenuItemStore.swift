//
//  MenuItemStore.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

class MenuItemStore: ObservableObject {
    @Published var appItems: [AppMenuItem] = []
    @Published var actionItems: [ActionMenuItem] = []

    // MARK: - Init

    init() {
        try? load()
        if appItems.isEmpty {
            Task{
                await appendItems(AppMenuItem.defaultApps)
            }
        }
    }

    // MARK: - Append Item

    @MainActor func appendItems<MenuItemType: MenuItem>(_ items: [MenuItemType]) {
        if let apps = items as? [AppMenuItem] {
            appItems.append(contentsOf: apps)
        }

        if let actions = items as? [ActionMenuItem] {
            actionItems.append(contentsOf: actions)
        }
        try? save()
    }

    @MainActor func appendItem<MenuItemType: MenuItem>(_ item: MenuItemType) {
        if let app = item as? AppMenuItem {
            appItems.append(app)
        }

        if let action = item as? ActionMenuItem {
            actionItems.append(action)
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
        let appItemsData = UserDefaults.group.data(forKey: "APP_ITEMS")!
        let actionItemsData = UserDefaults.group.data(forKey: "ACTION_ITEMS")!
        let decoder = PropertyListDecoder()
        let appItems = try decoder.decode([AppMenuItem].self, from: appItemsData)
        let actionItems = try decoder.decode([ActionMenuItem].self, from: actionItemsData)
        DispatchQueue.main.async {
            self.appItems = appItems
            self.actionItems = actionItems
        }
    }

    func save() throws {
        let encoder = PropertyListEncoder()
        let appItemsData = try encoder.encode(appItems)
        let actionItemsData = try encoder.encode(actionItems)
        UserDefaults.group.set(appItemsData, forKey: "APP_ITEMS")
        UserDefaults.group.set(actionItemsData, forKey: "ACTION_ITEMS")
        UserDefaults.group.set(true, forKey: "STORE_NEED_UPDATE")
    }
}

extension UserDefaults {
    static var group: UserDefaults {
        UserDefaults(suiteName: "group.top.kyleye.FinderHelper")!
    }
}
