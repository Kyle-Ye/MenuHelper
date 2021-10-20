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

    var name: String
    var enabled: Bool = true
    var actionIndex: Int

    var icon: NSImage { NSImage(named: "icon")! }
}

extension ActionMenuItem {
    static var all: [ActionMenuItem] = [.copyPath, .goParent]
    static let copyPath = ActionMenuItem(name: "Copy Path", actionIndex: 0)
    static let goParent = ActionMenuItem(name: "Go Parent Directory", actionIndex: 1)

    static let actions: [([URL]) -> Void] = [{ urls in
        let board = NSPasteboard.general
        board.clearContents()
        board.setString(urls[0].path, forType: .string)
    }, { urls in
        let url = urls[0].deletingLastPathComponent()
        NSWorkspace.shared.selectFile(url.path, inFileViewerRootedAtPath: "")
    }]
}
