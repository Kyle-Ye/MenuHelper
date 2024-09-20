//
//  MenuItemStore.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import OrderedCollections
import SwiftUI

@Observable
class MenuItemStore {
    var appItems: [AppMenuItem] = [] {
        didSet {
            try? save()
        }
    }
    var actionItems: [ActionMenuItem] = [] {
        didSet {
            try? save()
        }
    }

    // MARK: - Init

    nonisolated init() {
        Task {
            await MainActor.run {
                try? load()
            }
        }
    }

    func refresh() {
        try? load()
    }

    // MARK: - Append Item

    func appendItems(_ items: [AppMenuItem]) {
        appItems.append(contentsOf: items.filter { !appItems.contains($0) })
        try? save()
    }

    func appendItems(_ items: [ActionMenuItem]) {
        actionItems.append(contentsOf: items.filter { !actionItems.contains($0) })
        try? save()
    }

    func insertItems(_ items: [AppMenuItem], at index: Int) {
        appItems.insert(contentsOf: items.filter { !appItems.contains($0) }, at: index)
        try? save()
    }

    func insertItems(_ items: [ActionMenuItem], at index: Int) {
        actionItems.insert(contentsOf: items.filter { !actionItems.contains($0) }, at: index)
        try? save()
    }

    func appendItem(_ item: AppMenuItem) {
        if !appItems.contains(item) {
            appItems.append(item)
            try? save()
        }
    }

    func appendItem(_ item: ActionMenuItem) {
        if !actionItems.contains(item) {
            actionItems.append(item)
            try? save()
        }
    }

    // MARK: - Delete Items

    func deleteAppItems(offsets: IndexSet) {
        withAnimation {
            appItems.remove(atOffsets: offsets)
        }
        try? save()
    }

    func deleteActionItems(offsets: IndexSet) {
        withAnimation {
            actionItems.remove(atOffsets: offsets)
        }
        try? save()
    }

    func resetActionItems() {
        actionItems = ActionMenuItem.all
        try? save()
    }

    // MARK: - Move Items

    func moveAppItems(from source: IndexSet, to destination: Int) {
        withAnimation {
            appItems.move(fromOffsets: source, toOffset: destination)
        }
        try? save()
    }

    func moveActionItems(from source: IndexSet, to destination: Int) {
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

    // MARK: - Update Item

    func updateAppItem(item: AppMenuItem, index: Int?) {
        if let index = index {
            appItems[index] = item
        } else {
            appItems.append(item)
        }
        try? save()
    }

    // MARK: - UserDefaults
    
    static func migrateFromOldUserDefaults() {
        let oldGroup = UserDefaults.oldGroup
        let newGroup = UserDefaults.group
        
        if let appItemsData = oldGroup.data(forKey: "APP_ITEMS"),
           let actionItemsData = oldGroup.data(forKey: "ACTION_ITEMS") {
            newGroup.set(appItemsData, forKey: "APP_ITEMS")
            newGroup.set(actionItemsData, forKey: "ACTION_ITEMS")
        }
    }

    private func load() throws {
        if let appItemsData = UserDefaults.group.data(forKey: "APP_ITEMS"),
           let actionItemsData = UserDefaults.group.data(forKey: "ACTION_ITEMS") {
            let decoder = PropertyListDecoder()
            appItems = try decoder.decode([AppMenuItem].self, from: appItemsData)
            actionItems = try decoder.decode([ActionMenuItem].self, from: actionItemsData)
        } else {
            appItems = AppMenuItem.defaultApps
            actionItems = ActionMenuItem.all
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
    static let oldGroup: UserDefaults = {
        #if DEBUG
        UserDefaults(suiteName: "group.top.kyleye.MenuHelperDebug")!
        #else
        UserDefaults(suiteName: "group.top.kyleye.MenuHelper")!
        #endif
    }()
    
    static let group: UserDefaults = {
        #if DEBUG
        UserDefaults(suiteName: "VB7MJ8R223.top.kyleye.MenuHelperDebug")!
        #else
        UserDefaults(suiteName: "VB7MJ8R223.top.kyleye.MenuHelper")!
        #endif
    }()
}
