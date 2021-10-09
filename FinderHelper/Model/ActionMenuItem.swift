//
//  ActionMenuItem.swift
//  ActionMenuItem
//
//  Created by Kyle on 2021/10/9.
//

import Foundation

struct ActionMenuItem: MenuItem {
    static func == (lhs: ActionMenuItem, rhs: ActionMenuItem) -> Bool {
        lhs.name == rhs.name
    }

    var name: String
    var enabled: Bool = true
    var actionIndex: Int
}

extension ActionMenuItem {
    static let copyPath = ActionMenuItem(name: "Copy Path", actionIndex: 0)

    static let actions: [([URL]) -> Void] = [
        { urls in
            // TODO: - Copy to clipborad
            print(urls)
        }
    ]
}
