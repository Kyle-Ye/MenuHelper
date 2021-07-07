//
//  FinderSync.swift
//  FinderMenu
//
//  Created by Kyle on 2021/6/27.
//

import Cocoa
import Darwin
import FinderSync

class FinderSync: FIFinderSync {
    override init() {
        super.init()
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        // TODO: - 
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
        // TODO: - switch in menuKind
        // Produce a menu for the extension.
        let menu = NSMenu(title: "FinderHelper")
        for item in store.items {
            let menuItem = NSMenuItem(title: "Open in \(item.name)", action: #selector(openUsingSender(_:)), keyEquivalent: "")
            menuItem.image = item.icon
            menu.addItem(menuItem)
        }
        return menu
    }
    
    @IBAction func openUsingSender(_ sender: AnyObject?) {
        guard let targetURL = FIFinderSyncController.default().targetedURL(),
              let itemURLs = FIFinderSyncController.default().selectedItemURLs(),
              let menuItem = sender as? NSMenuItem
        else {
            return
        }
        
        NSLog("Open URL: using: %@, target = %@, items = [%@]", menuItem.title, targetURL.path, itemURLs.map(\.path).joined(separator: ",\n"))
        if let appURL = store.getAppURL(from: menuItem.title) {
            let urls: [URL]
            if itemURLs.isEmpty {
                urls = [targetURL]
            } else {
                urls = itemURLs
            }
            let config = NSWorkspace.OpenConfiguration()
            config.promptsUserIfNeeded = true
            NSWorkspace.shared.open(urls, withApplicationAt: appURL, configuration: config) { _, _ in
            }
        }
    }
}
