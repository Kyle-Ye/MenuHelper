//
//  AppCommChannel.swift
//  MenuHelper
//
//  Created by Kyle on 2021/10/20.
//

import Foundation
import os.log

private let logger = Logger(subsystem: subsystem, category: "app_comm_channel")

class AppCommChannel {
    weak var folderItemStore: FolderItemStore?
    func setup(store: FolderItemStore) {
        let center = DistributedNotificationCenter.default()
        center.addObserver(self, selector: #selector(refreshFolderItems(_:)), name: .init(rawValue: "RefreshFolderItems"), object: bundleIdentifier)
        folderItemStore = store
    }

    func send(name: String, data: [AnyHashable: Any]? = nil) {
        logger.notice("Sending \(name) data: \(data ?? [:])")
        DistributedNotificationCenter.default()
            .postNotificationName(.init(rawValue: name),
                                  object: bundleIdentifier,
                                  userInfo: data,
                                  deliverImmediately: true)
    }

    @MainActor @objc func refreshFolderItems(_ notification: Notification) {
        folderItemStore?.refresh()
    }
}
