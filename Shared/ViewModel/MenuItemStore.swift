//
//  MenuItemStore.swift
//  MenuHelper
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

    func refresh() {
        try? load()
    }

    // MARK: - Toggle Item

    @MainActor func toggleItem(_ item: AppMenuItem) {
        if let index = appItems.firstIndex(of: item) {
            appItems[index].enabled.toggle()
            try? save()
        }
    }

    @MainActor func toggleItem(_ item: ActionMenuItem) {
        if let index = actionItems.firstIndex(of: item) {
            actionItems[index].enabled.toggle()
            try? save()
        }
    }

    // MARK: - Append Item

    @MainActor func appendItems(_ items: [AppMenuItem]) {
        appItems.append(contentsOf: items.filter { !appItems.contains($0) })
        try? save()
    }

    @MainActor func appendItems(_ items: [ActionMenuItem]) {
        actionItems.append(contentsOf: items.filter { !actionItems.contains($0) })
        try? save()
    }

    @MainActor func insertItems(_ items: [AppMenuItem], at index: Int) {
        appItems.insert(contentsOf: items.filter { !appItems.contains($0) }, at: index)
        try? save()
    }

    @MainActor func insertItems(_ items: [ActionMenuItem], at index: Int) {
        actionItems.insert(contentsOf: items.filter { !actionItems.contains($0) }, at: index)
        try? save()
    }

    @MainActor func appendItem(_ item: AppMenuItem) {
        if !appItems.contains(item) {
            appItems.append(item)
            try? save()
        }
    }

    @MainActor func appendItem(_ item: ActionMenuItem) {
        if !actionItems.contains(item) {
            actionItems.append(item)
            try? save()
        }
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

    private func load() throws {
        if let appItemData = UserDefaults.group.data(forKey: "APP_ITEMS"),
           let actionItemData = UserDefaults.group.data(forKey: "ACTION_ITEMS") {
            let decoder = PropertyListDecoder()
            var appItems = try decoder.decode([AppMenuItem].self, from: appItemData)
            let actionItems = try decoder.decode([ActionMenuItem].self, from: actionItemData)
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
        channel.send(name: "RefreshMenuItems")
    }
}

extension UserDefaults {
    static var group: UserDefaults {
        UserDefaults(suiteName: "group.top.kyleye.MenuHelper")!
    }
}
