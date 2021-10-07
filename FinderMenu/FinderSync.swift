//
//  FinderSync.swift
//  FinderMenu
//
//  Created by Kyle on 2021/6/27.
//

import Cocoa
import Darwin
import FinderSync
import os.log

let logger = Logger(subsystem: "top.kyleye.FinderHelper.FinderMenu", category: "menu")

class FinderSync: FIFinderSync {
    override init() {
        super.init()
        logger.notice("FinderSync() launched from \(Bundle.main.bundlePath, privacy: .public)")
        // Get home directory
        if let pw = getpwuid(getuid()), let home = pw.pointee.pw_dir {
            let path = FileManager.default.string(withFileSystemRepresentation: home, length: strlen(home))
            let home = URL(fileURLWithPath: path)
            FIFinderSyncController.default().directoryURLs = [home]
            logger.notice("FIFinderSyncController directoryURLs: \(FIFinderSyncController.default().directoryURLs, privacy: .public)")
        }
    }

    // MARK: - Menu and toolbar item support

    override var toolbarItemName: String {
        return "FinderHelper"
    }

    override var toolbarItemToolTip: String {
        return "FinderHelper Menu"
    }

    override var toolbarItemImage: NSImage {
        let image = NSImage(systemSymbolName: "terminal", accessibilityDescription: "FinderHelper Menu")!
        return image
    }

    let store = AppMenuItemStore()

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // NOTE: contextualMenuForSidebar will not called since macOS Big Sur
        // Produce a menu for the extension.
        logger.notice("Create menu for \(menuKind.rawValue)")
        let menu = NSMenu(title: "FinderHelper")
        menu.showsStateColumn = true
        for (index, item) in store.items.enumerated() {
            let menuItem = NSMenuItem()
            menuItem.target = self
            menuItem.title = "Open in \(item.name)"
            menuItem.action = #selector(openUsingSender(_:))
            menuItem.toolTip = "item.name"
            menuItem.tag = index
            if menuKind == .toolbarItemMenu {
                menuItem.image = item.icon
            }
            menu.addItem(menuItem)
        }
        return menu
    }

    @objc func openUsingSender(_ menuItem: NSMenuItem) {
        guard let targetURL = FIFinderSyncController.default().targetedURL(),
              let itemURLs = FIFinderSyncController.default().selectedItemURLs() else { return }
        logger.notice("Click menu \"\(menuItem.title, privacy: .public)\", index = \(menuItem.tag, privacy: .public), target = \(targetURL, privacy: .public), items = \(itemURLs, privacy: .public)]")

        if let appURL = store.getAppURL(from: menuItem.tag) {
            let urls = itemURLs.isEmpty ? [targetURL] : itemURLs
            let config = NSWorkspace.OpenConfiguration()
            config.promptsUserIfNeeded = true
            NSWorkspace.shared.open(urls, withApplicationAt: appURL, configuration: config) { application, error in
                if let error = error {
                    logger.error("Error: \(error.localizedDescription)")
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
        //            let home = URL(fileURLWithPath: "\(NSHomeDirectory())/Downloads")
        //            let urls = [home]
        //            targetURL.startAccessingSecurityScopedResource()
        //            NSWorkspace.shared.activateFileViewerSelecting([targetURL])
        //            NSWorkspace.shared.selectFile(targetURL.path, inFileViewerRootedAtPath: "")
        //            targetURL.stopAccessingSecurityScopedResource()ˆ
    }
}
