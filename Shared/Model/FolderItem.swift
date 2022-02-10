//
//  FolderItem.swift
//  MenuHelper
//
//  Created by Kyle on 2021/10/20.
//

import Foundation

protocol FolderItem: Hashable, Identifiable, Codable {
    var path: String { get }
}

extension FolderItem {
    var id: String { path }
}
