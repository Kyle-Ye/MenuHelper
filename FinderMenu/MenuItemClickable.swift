//
//  MenuItemClickable.swift
//  MenuItemClickable
//
//  Created by Kyle on 2021/10/9.
//

import AppKit
import Foundation
import os.log

private let logger = Logger(subsystem: subsystem, category: "menu_click")

protocol MenuItemClickable {
    func menuClick(with urls: [URL])
}

extension AppMenuItem: MenuItemClickable {
    func menuClick(with urls: [URL]) {
        let config = NSWorkspace.OpenConfiguration()
        config.promptsUserIfNeeded = true
        NSWorkspace.shared.open(urls, withApplicationAt: url, configuration: config) { application, error in
            if let error = error as? CocoaError,
               let underlyingError = error.userInfo["NSUnderlyingError"] as? NSError {
                logger.error("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    if underlyingError._code == -10820 {
                        let alert = NSAlert(error: error)
                        alert.addButton(withTitle: "OK")
                        alert.addButton(withTitle: "Remove app")
                        switch alert.runModal() {
                        case .alertFirstButtonReturn:
                            logger.notice("Dismiss error with OK")
                        case .alertSecondButtonReturn:
                            logger.notice("Dismiss error with Remove app")
                            if let index = menuStore.appItems.firstIndex(of: self) {
                                menuStore.deleteAppItems(offsets: IndexSet(integer: index))
                            }
                        default:
                            break
                        }
                    } else {
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = true
                        panel.allowedContentTypes = [.folder]
                        panel.canChooseDirectories = true
                        panel.directoryURL = URL(fileURLWithPath: urls[0].path)
                        if panel.runModal() == .OK {
                            folderStore.appendItems(panel.urls.map { FolderItem($0) })
                        }
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
    func menuClick(with urls: [URL]) {
        ActionMenuItem.actions[actionIndex](urls)
    }
}
