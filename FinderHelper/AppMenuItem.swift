//
//  AppMenuItem.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/28.
//

import AppKit
import Foundation

struct AppMenuItem {
    
    
    init?(bundleIdentifier identifier: String) {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier) else {
            return nil
        }
        self.init(appURL: url)
    }

    init(appURL url: URL) {
        self.url = url
        icon = NSWorkspace.shared.icon(forFile: url.path)
    }

    var url: URL
    var icon: NSImage
    var name: String {
        url.path.lazy.split(separator: ".").map { String($0) }.last ?? ""
    }
}


extension AppMenuItem {
//    static let xcode = AppMenuItem(app
    static let xcodeBeta = AppMenuItem(bundleIdentifier: "com.apple.dt.Xcode")!
    static let vscode = AppMenuItem(bundleIdentifier: "com.microsoft.VSCode")!
}
