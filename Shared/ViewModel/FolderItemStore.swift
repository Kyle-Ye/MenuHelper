//
//  FolderItemStore.swift
//  FolderItemStore
//
//  Created by Kyle on 2021/10/10.
//

import FinderSync
import OrderedCollections
import os.log
import SwiftUI

private let logger = Logger(subsystem: subsystem, category: "folder_item_store")

@Observable
final class FolderItemStore: Sendable {
    private(set) var bookmarkItems: [BookmarkFolderItem] = []
    private(set) var syncItems: [SyncFolderItem] = []

    // MARK: - Init

    nonisolated init() {
        Task {
            await MainActor.run {
                try? load()
            }
        }
    }

    nonisolated func refresh() {
        Task {
            await MainActor.run {
                try? load()
            }
        }
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

    func deleteAllBookmarkItems() {
        withAnimation {
            bookmarkItems.removeAll()
        }
        Task.detached {
            try await self.save()
        }
    }

    func deleteAllSyncItems() {
        withAnimation {
            syncItems.removeAll()
        }
        Task.detached {
            try await self.save()
        }
    }

    // MARK: - UserDefaults

    @MainActor
    private func load() throws {
        if let bookmarkItemData = UserDefaults.group.data(forKey: "BOOKMARK_ITEMS"),
           let syncItemData = UserDefaults.group.data(forKey: "SYNC_ITEMS") {
            let decoder = PropertyListDecoder()
            bookmarkItems = try decoder.decode([BookmarkFolderItem].self, from: bookmarkItemData)
            let syncItems = try decoder.decode([SyncFolderItem].self, from: syncItemData)
            self.syncItems = syncItems
            FIFinderSyncController.default().directoryURLs = Set(syncItems.map { URL(fileURLWithPath: $0.path) })
            logger.notice("Sync directory set to \(syncItems.map(\.path).joined(separator: "\n"), privacy: .public)")
        } else {
            let syncItems = SyncFolderItem.defaultFolders
            self.syncItems = syncItems
            FIFinderSyncController.default().directoryURLs = Set(syncItems.map { URL(fileURLWithPath: $0.path) })
            logger.notice("Sync directory set to \(syncItems.map(\.path).joined(separator: "\n"), privacy: .public)")
        }
    }

    @MainActor
    private func save() throws {
        let encoder = PropertyListEncoder()
        let bookmarkItemData = try encoder.encode(OrderedSet(bookmarkItems))
        let syncItemData = try encoder.encode(OrderedSet(syncItems))
        UserDefaults.group.set(bookmarkItemData, forKey: "BOOKMARK_ITEMS")
        UserDefaults.group.set(syncItemData, forKey: "SYNC_ITEMS")
        channel.send(name: "RefreshFolderItems")
    }
}
