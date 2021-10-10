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
            let application = URL(fileURLWithPath: "/Applications")
            FIFinderSyncController.default().directoryURLs = [home, application]
            logger.notice("FIFinderSyncController directoryURLs: \(FIFinderSyncController.default().directoryURLs, privacy: .public)")
        }
    }

    // MARK: - Menu and toolbar item support

    override var toolbarItemName: String { showToolbarItemMenu ? "FinderHelper" : "" }

    override var toolbarItemToolTip: String { showToolbarItemMenu ? "FinderHelper Menu" : "" }

    override var toolbarItemImage: NSImage { showToolbarItemMenu ? NSImage(systemSymbolName: "terminal", accessibilityDescription: "FinderHelper Menu")! : NSImage() }

    let store = MenuItemStore()

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

        if storeNeedUpdate {
            try? store.load()
            storeNeedUpdate = false
        }

        // Produce a menu for the extension.
        logger.notice("Create menu for \(menuKind.rawValue)")
        let menu = NSMenu(title: "FinderHelper")
        menu.showsStateColumn = true
        for item in store.appItems.filter(\.enabled) {
            let menuItem = NSMenuItem()
            menuItem.target = self
            menuItem.title = "Open in \(item.name)"
            menuItem.action = #selector(menuAction(_:))
            menuItem.toolTip = "\(item.name)"
            menuItem.tag = 0
            if menuKind == .toolbarItemMenu {
                menuItem.image = item.icon
            }
            menu.addItem(menuItem)
        }
        for item in store.actionItems.filter(\.enabled) {
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
            let item = store.getAppItem(name: menuItem.title)
            item?.menuClick(with: urls, in: store)
        case 1:
            let item = store.getActionItem(name: menuItem.title)
            item?.menuClick(with: urls, in: store)
        default:
            break
        }
        //            let home = URL(fileURLWithPath: "\(NSHomeDirectory())/Downloads")
        //            let urls = [home]
        //            targetURL.startAccessingSecurityScopedResource()
        //            NSWorkspace.shared.activateFileViewerSelecting([targetURL])
        //            NSWorkspace.shared.selectFile(targetURL.path, inFileViewerRootedAtPath: "")
        //            targetURL.stopAccessingSecurityScopedResource()ˆ
    }
}
