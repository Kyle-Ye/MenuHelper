//
//  FolderItemStore.swift
//  FolderItemStore
//
//  Created by Kyle on 2021/10/10.
//

import OrderedCollections
import SwiftUI

class FolderItemStore: ObservableObject {
    @Published var folderItems: [FolderItem] = []
//    @Published var syncFolderItems: [FolderItem]

    // MARK: - Init

    init() {
        try? load()
    }

    // MARK: - Append Item

    @MainActor func appendItems(_ items: [FolderItem]) {
        folderItems.append(contentsOf: items.filter { !folderItems.contains($0) })
        try? save()
    }

    @MainActor func appendItem(_ item: FolderItem) {
        if !folderItems.contains(item) {
            folderItems.append(item)
        }
        try? save()
    }

    // MARK: - Delete Items

    @MainActor func deleteItems(offsets: IndexSet) {
        withAnimation {
            folderItems.remove(atOffsets: offsets)
        }
        try? save()
    }

    // MARK: - UserDefaults

    func load() throws {
        if let folderItemsData = UserDefaults.group.data(forKey: "FOLDER_ITEMS") {
            let decoder = PropertyListDecoder()
            let folderItems = try decoder.decode([FolderItem].self, from: folderItemsData)
            DispatchQueue.main.async {
                self.folderItems = folderItems
            }
        }
    }

    private func save() throws {
        let encoder = PropertyListEncoder()
        let folderItemData = try encoder.encode(OrderedSet(folderItems))
        UserDefaults.group.set(folderItemData, forKey: "FOLDER_ITEMS")
        UserDefaults.group.set(true, forKey: "FOLDER_ITEM_STORE_NEED_UPDATE")
    }
}
