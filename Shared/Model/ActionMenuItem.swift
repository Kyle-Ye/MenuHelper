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
    static let copyPath = ActionMenuItem(name: "Copy Path", actionIndex: 0)

    static let actions: [([URL]) -> Void] = [
        { urls in
            let board = NSPasteboard.general
            board.clearContents()
            board.setString(urls[0].path, forType: .string)
        }
    ]
}
