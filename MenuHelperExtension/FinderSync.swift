//
//  FinderSync.swift
//  MenuHelperExtension
//
//  Created by Kyle on 2021/6/27.
//

import Cocoa
import Darwin
import FinderSync
import os.log

let menuStore = MenuItemStore()
let folderStore = FolderItemStore()
let channel = FinderCommChannel()
private let logger = Logger(subsystem: subsystem, category: "menu")

class FinderSync: FIFinderSync {
    override init() {
        super.init()
        channel.setup()
        logger.notice("FinderSync() launched from \(Bundle.main.bundlePath, privacy: .public)")
        FIFinderSyncController.default().directoryURLs = Set(folderStore.syncItems.map { URL(fileURLWithPath: $0.path) })
        logger.notice("Init sync directory is \(folderStore.syncItems.map(\.path).joined(separator: "\n"), privacy: .public)")
    }

    // MARK: - Menu and toolbar item support

    override var toolbarItemName: String { showToolbarItemMenu ? "MenuHelper" : "" }

    override var toolbarItemToolTip: String { showToolbarItemMenu ? "MenuHelper Menu" : "" }

    override var toolbarItemImage: NSImage {
        func defaultImage() -> NSImage {
            logger.info("showToolbarItemMenu: \(self.showToolbarItemMenu, privacy: .public)")
            return NSImage()
        }
        if showToolbarItemMenu {
            return NSImage(systemSymbolName: "terminal", accessibilityDescription: "MenuHelper Menu") ?? defaultImage()
        } else {
            return defaultImage()
        }
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        switch menuKind {
        case .contextualMenuForItems:
            if !showContextualMenuForItem { return NSMenu() }
        case .contextualMenuForContainer:
            if !showContextualMenuForContainer { return NSMenu() }
        // NOTE: contextualMenuForSidebar will not called since macOS Big Sur
        case .contextualMenuForSidebar:
            if !showContextualMenuForSidebar { return NSMenu() }
        case .toolbarItemMenu:
            if !showToolbarItemMenu { return NSMenu() }
        @unknown default:
            break
        }
        // Produce a menu for the extension.
        logger.notice("Create menu for \(menuKind.rawValue)")
        let menu = NSMenu(title: "MenuHelper")
        menu.showsStateColumn = true
        for item in menuStore.appItems.filter(\.enabled) {
            let menuItem = NSMenuItem()
            menuItem.target = self
            menuItem.title = String(format: NSLocalizedString("Open in %@", comment: "Open in the given application"), item.name)
            menuItem.action = #selector(menuAction(_:))
            menuItem.toolTip = "\(item.name)"
            menuItem.tag = 0
            if menuKind == .toolbarItemMenu {
                menuItem.image = item.icon
            }
            menu.addItem(menuItem)
        }
        for item in menuStore.actionItems.filter(\.enabled) {
            let menuItem = NSMenuItem()
            menuItem.target = self
            menuItem.title = item.name
            menuItem.action = #selector(menuAction(_:))
            menuItem.toolTip = "\(item.name)"
            menuItem.tag = 1
            if menuKind == .toolbarItemMenu {
                menuItem.image = item.icon
            }
            menu.addItem(menuItem)
        }
        return menu
    }

    @objc func menuAction(_ menuItem: NSMenuItem) {
        guard let targetURL = FIFinderSyncController.default().targetedURL(),
              let itemURLs = FIFinderSyncController.default().selectedItemURLs() else { return }
        logger.notice("Click menu \"\(menuItem.title, privacy: .public)\", index = \(menuItem.tag, privacy: .public), target = \(targetURL, privacy: .public), items = \(itemURLs, privacy: .public)]")

        let urls = itemURLs.isEmpty ? [targetURL] : itemURLs
        switch menuItem.tag {
        case 0:
            let item = menuStore.getAppItem(name: menuItem.title)
            item?.menuClick(with: urls)
        case 1:
            let item = menuStore.getActionItem(name: menuItem.title)
            item?.menuClick(with: urls)
        default:
            break
        }
    }
}
