//
//  FolderItemStore.swift
//  FolderItemStore
//
//  Created by Kyle on 2021/10/10.
//

import OrderedCollections
import SwiftUI
import FinderSync

class FolderItemStore: ObservableObject {
    @Published private(set) var bookmarkItems: [BookmarkFolderItem] = []
    @Published private(set) var syncItems: [SyncFolderItem] = []

    // MARK: - Init

    init() {
        try? load()
    }

    func refresh() {
        try? load()
    }

    // MARK: - Append Item

    @MainActor func appendItems(_ items: [BookmarkFolderItem]) {
        bookmarkItems.append(contentsOf: items.filter { !bookmarkItems.contains($0) })
        try? save()
    }

    @MainActor func appendItems(_ items: [SyncFolderItem]) {
        syncItems.append(contentsOf: items.filter { !syncItems.contains($0) })
        try? save()
    }

    @MainActor func insertItems(_ items: [BookmarkFolderItem], at index: Int) {
        bookmarkItems.insert(contentsOf: items.filter { !bookmarkItems.contains($0) }, at: index)
        try? save()
    }

    @MainActor func insertItems(_ items: [SyncFolderItem], at index: Int) {
        syncItems.insert(contentsOf: items.filter { !syncItems.contains($0) }, at: index)
        try? save()
    }

    @MainActor func appendItem(_ item: BookmarkFolderItem) {
        if !bookmarkItems.contains(item) {
            bookmarkItems.append(item)
        }
        try? save()
    }

    @MainActor func appendItem(_ item: SyncFolderItem) {
        if !syncItems.contains(item) {
            syncItems.append(item)
        }
        try? save()
    }

    // MARK: - Delete Items

    @MainActor func deleteBookmarkItems(offsets: IndexSet) {
        withAnimation {
            bookmarkItems.remove(atOffsets: offsets)
        }
        try? save()
    }

    @MainActor func deleteSyncItems(offsets: IndexSet) {
        withAnimation {
            syncItems.remove(atOffsets: offsets)
        }
        try? save()
    }
    // MARK: - UserDefaults

    private func load() throws {
        if let bookmarkItemData = UserDefaults.group.data(forKey: "BOOKMARK_ITEMS"),
           let syncItemData = UserDefaults.group.data(forKey: "SYNC_ITEMS") {
            let decoder = PropertyListDecoder()
            let bookmarkItems = try decoder.decode([BookmarkFolderItem].self, from: bookmarkItemData)
            var syncItems = try decoder.decode([SyncFolderItem].self, from: syncItemData)
            if syncItems.isEmpty {
                syncItems = SyncFolderItem.defaultFolders
            }
            DispatchQueue.main.async {
                self.bookmarkItems = bookmarkItems
                self.syncItems = syncItems
                FIFinderSyncController.default().directoryURLs = Set(syncItems.map { URL(fileURLWithPath: $0.path) })
            }
        }
    }

    private func save() throws {
        let encoder = PropertyListEncoder()
        let bookmarkItemData = try encoder.encode(OrderedSet(bookmarkItems))
        let syncItemData = try encoder.encode(OrderedSet(syncItems))
        UserDefaults.group.set(bookmarkItemData, forKey: "BOOKMARK_ITEMS")
        UserDefaults.group.set(syncItemData, forKey: "SYNC_ITEMS")
        channel.send(name: "RefreshFolderItems")
    }
}
