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
        let home = URL(fileURLWithPath: "/Users/kyle")
//        let home = URL(fileURLWithPath: NSHomeDirectory())
        FIFinderSyncController.default().directoryURLs = [home]
//        NSWorkspace.shared.open(home)
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        
        let path = #"/Applications/Visual Studio Code.app"#
        let app = URL(fileURLWithPath: path)
        
        let config = NSWorkspace.OpenConfiguration()
        config.promptsUserIfNeeded = true
        NSWorkspace.shared.open([home], withApplicationAt: app, configuration: config) { app, error in
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
    
    let items = ["Xcode", "Visual Studio Code", "Terminal"]
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        let menu = NSMenu(title: "Test")
        
        for item in items {
            let menuItem = NSMenuItem(title: item, action: #selector(openUsingSender(_:)), keyEquivalent: "")
            menuItem.image = nil
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
        if itemURLs.isEmpty {
            openURL(targetURL, using: menuItem.title)
        } else {
            for itemURL in itemURLs {
                openURL(itemURL, using: menuItem.title)
            }
        }
    }
    
    @discardableResult
    private func openURL(_ url: URL, using app: String) -> Int {

        let path = #"/Applications/Visual Studio Code.app"#
        let app = URL(fileURLWithPath: path)
        
        let config = NSWorkspace.OpenConfiguration()
        config.promptsUserIfNeeded = true
        
        NSWorkspace.shared.open([url], withApplicationAt: app, configuration: config) { app, error in
        }
        return 0
//        let task = Process()
//        let pipe = Pipe()
//        task.standardOutput = pipe
//        task.standardError = pipe
//        task.launchPath = "/usr/bin/open"
//        task.arguments = ["-a", app, url.path]
//        task.launch()
//        task.waitUntilExit()
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let string = String(data: data, encoding: .utf8)
//        print("\(string)")
//        return Int(task.terminationStatus)
    }
}
