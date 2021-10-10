//
//  MenuItem.swift
//  MenuItem
//
//  Created by Kyle on 2021/10/9.
//

import AppKit

protocol MenuItem: Hashable, Identifiable, Codable {
    var name: String { get }
    var enabled: Bool { get set }
    var icon: NSImage { get }
}

extension MenuItem {
    var id: String { name }
}
