//
//  SyncFolderItem.swift
//  MenuHelper
//
//  Created by Kyle on 2021/10/20.
//

import Foundation

struct SyncFolderItem: FolderItem {
    var path: String

    init(_ url: URL) {
        path = url.path
    }
}

extension SyncFolderItem {
    static let home: SyncFolderItem? = {
        guard let pw = getpwuid(getuid()),
              let home = pw.pointee.pw_dir else {
            return nil
        }
        let path = FileManager.default.string(withFileSystemRepresentation: home, length: strlen(home))
        let url = URL(fileURLWithPath: path)
        return SyncFolderItem(url)
    }()

    static let application = SyncFolderItem(URL(fileURLWithPath: "/Applications"))

    static var defaultFolders: [SyncFolderItem] {
        [.home, .application].compactMap { $0 }
    }
}
