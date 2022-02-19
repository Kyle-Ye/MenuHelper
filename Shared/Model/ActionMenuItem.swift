//
//  ActionMenuItem.swift
//  ActionMenuItem
//
//  Created by Kyle on 2021/10/9.
//

import AppKit
import Foundation

struct ActionMenuItem: MenuItem {
    static func == (lhs: ActionMenuItem, rhs: ActionMenuItem) -> Bool {
        lhs.name == rhs.name
    }

    var key: String
    var comment: String = ""
    var name: String { NSLocalizedString(key, comment: "") }
    var enabled: Bool = true
    var actionIndex: Int

    var icon: NSImage { NSImage(named: "icon")! }
}

extension ActionMenuItem {
    static var all: [ActionMenuItem] = [.copyPath, .goParent, .newFile]

    static let copyPath = ActionMenuItem(key: "Copy Path", actionIndex: 0)
    static let goParent = ActionMenuItem(key: "Go Parent Directory", actionIndex: 1)
    static let newFile = ActionMenuItem(key: "New File", actionIndex: 2)

    #if DEBUG
    // FIXME: - Refactor this when compiler time const is introduced to Swift
    private static let copyPathString = NSLocalizedString("Copy Path", comment: "Copy Path")
    private static let goParentString = NSLocalizedString("Go Parent Directory", comment: "Go Parent Directory")
    private static let newFileString = NSLocalizedString("New File", comment: "New File")
    #endif
}

