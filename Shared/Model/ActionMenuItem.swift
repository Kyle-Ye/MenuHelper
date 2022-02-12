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
    var name: String { NSLocalizedString(key, comment: comment) }
    var enabled: Bool = true
    var actionIndex: Int

    var icon: NSImage { NSImage(named: "icon")! }
}

extension ActionMenuItem {
    static var all: [ActionMenuItem] = [.copyPath, .goParent]

    static let copyPath = ActionMenuItem(key: "Copy Path", actionIndex: 0)
    static let goParent = ActionMenuItem(key: "Go Parent Directory", actionIndex: 1)

    #if DEBUG
    // FIXME: - Refactor this when compiler time const is introduced to Swift
    private static let copyPathString = NSLocalizedString("Copy Path", comment: "Copy Path")
    private static let goParentString = NSLocalizedString("Go Parent Directory", comment: "Go Parent Directory")
    #endif

    static let actions: [([URL]) -> Void] = [{ urls in
        let board = NSPasteboard.general
        board.clearContents()
        board.setString(urls[0].path, forType: .string)
    }, { urls in
        let url = urls[0].deletingLastPathComponent()
        NSWorkspace.shared.selectFile(url.path, inFileViewerRootedAtPath: "")
    }]
}
