//
//  MenuItemClickable.swift
//  MenuItemClickable
//
//  Created by Kyle on 2021/10/9.
//

import AppKit
import Foundation

protocol MenuItemClickable {
    func menuClick(with urls: [URL], in store: MenuItemStore)
}

extension AppMenuItem: MenuItemClickable {
    func menuClick(with urls: [URL], in store: MenuItemStore) {
        let config = NSWorkspace.OpenConfiguration()
        config.promptsUserIfNeeded = true
        NSWorkspace.shared.open(urls, withApplicationAt: url, configuration: config) { application, error in
            if let error = error {
                logger.error("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = NSAlert(error: error)
                    alert.addButton(withTitle: "OK")
                    alert.addButton(withTitle: "Remove app")
                    switch alert.runModal() {
                    case .alertFirstButtonReturn:
                        logger.notice("Dismiss error with OK")
                    case .alertSecondButtonReturn:
                        logger.notice("Dismiss error with Remove app")
                        if let index = store.appItems.firstIndex(of: self) {
                            store.deleteAppItems(offsets: IndexSet(integer: index))
                        }
                    default:
                        break
                    }
                }
                return
            }
            if let application = application {
                if let path = application.bundleURL?.path,
                   let identifier = application.bundleIdentifier,
                   let date = application.launchDate {
                    logger.notice("Success: open \(identifier, privacy: .public) app at \(path, privacy: .public) in \(date, privacy: .public)")
                }
            }
        }
    }
}

extension ActionMenuItem: MenuItemClickable {
    func menuClick(with urls: [URL], in store: MenuItemStore) {
        ActionMenuItem.actions[actionIndex](urls)
    }
}
