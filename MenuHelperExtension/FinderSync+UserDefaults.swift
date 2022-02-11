//
//  FinderSync+UserDefaults.swift
//  MenuHelperExtension
//
//  Created by Kyle on 2021/10/9.
//

import Foundation
import os.log

private let logger = Logger(subsystem: subsystem, category: "user_defaults")

extension FinderSync {
    var showContextualMenuForItem: Bool {
        defaults(for: "SHOW_CONTEXTUAL_MENU_FOR_ITEM")
    }

    var showContextualMenuForContainer: Bool {
        defaults(for: "SHOW_CONTEXTUAL_MENU_FOR_CONTAINER")
    }

    var showContextualMenuForSidebar: Bool {
        defaults(for: "SHOW_CONTEXTUAL_MENU_FOR_SIDEBAR")
    }

    var showToolbarItemMenu: Bool {
        defaults(for: "SHOW_TOOLBAR_ITEM_MENU")
    }

    private func defaults(for key: String) -> Bool {
        if let value = UserDefaults.group.object(forKey: key) as? Bool {
            return value
        } else {
            logger.info("Missing key for \(key, privacy: .public), using default true value")
            return true
        }
    }
}
