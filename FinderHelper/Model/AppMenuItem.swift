//
//  AppMenuItem.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/28.
//

import AppKit
import Foundation

struct AppMenuItem: MenuItem {
    init(appURL url: URL) {
        self.url = url
        itemName = url.deletingPathExtension().lastPathComponent
    }

    var url: URL
    var icon: NSImage { NSWorkspace.shared.icon(forFile: url.path) }
    var itemName: String
    var enabled: Bool = true

    var appName: String {
        url.deletingPathExtension().lastPathComponent
    }

    var name: String {
        itemName.isEmpty ? appName : itemName
    }
}

extension AppMenuItem {
    init?(bundleIdentifier identifier: String) {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier) else {
            return nil
        }
        self.init(appURL: url)
    }

    static let xcode = AppMenuItem(bundleIdentifier: "com.apple.dt.Xcode")
    static let vscode = AppMenuItem(bundleIdentifier: "com.microsoft.VSCode")
    static let terminal = AppMenuItem(bundleIdentifier: "com.apple.Terminal")
    static var defaultApps: [AppMenuItem] {
        [.xcode, .vscode, .terminal].compactMap { $0 }
    }
}
