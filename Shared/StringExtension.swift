//
//  StringExtension.swift
//  MenuHelper
//
//  Created by Kyle on 2021/10/20.
//

import Foundation

let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
var subsystem: String { bundleIdentifier }

enum Key {
    static let showContextualMenuForItem = "SHOW_CONTEXTUAL_MENU_FOR_ITEM"
    static let showContextualMenuForContainer = "SHOW_CONTEXTUAL_MENU_FOR_CONTAINER"
    static let showContextualMenuForSidebar = "SHOW_CONTEXTUAL_MENU_FOR_SIDEBAR"
    static let showToolbarItemMenu = "SHOW_TOOLBAR_ITEM_MENU"

    static let copyPathSeparator = "COPY_PATH_SEPARATOR"
    static let copyPathOption = "COPY_PATH_OPTION"
    static let newFileName = "NEW_FILE_NAME"
    static let newFileExtension = "NEW_FILE_EXTENSION"

    static let showSubMenuForApplication = "SHOW_SUB_MENU_FOR_APPLICATION"
    static let showSubMenuForAction = "SHOW_SUB_MENU_FOR_ACTION"
}

enum CopyPathOption: Int, CustomStringConvertible, CaseIterable, Identifiable {
    var id: Int { rawValue }

    case origin, escape, quoto

    var description: String {
        switch self {
        case .origin: return NSLocalizedString("Use origin path", comment: "")
        case .escape: return NSLocalizedString("Escape \" \" with \"\\ \" ", comment: "")
        case .quoto: return NSLocalizedString("Wrap entire path with \"\"", comment: "")
        }
    }
}

enum NewFileExtension: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case none = ""
    case swift
    case txt
}
