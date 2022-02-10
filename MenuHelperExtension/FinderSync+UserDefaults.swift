//
//  FinderSync+UserDefaults.swift
//  MenuHelperExtension
//
//  Created by Kyle on 2021/10/9.
//

import Foundation

extension FinderSync {
    var showContextualMenuForItem: Bool {
        UserDefaults.group.bool(forKey: "SHOW_CONTEXTUAL_MENU_FOR_ITEM")
    }
    
    var showContextualMenuForContainer: Bool {
        UserDefaults.group.bool(forKey: "SHOW_CONTEXTUAL_MENU_FOR_CONTAINER")
    }
    
    var showContextualMenuForSidebar: Bool {
        UserDefaults.group.bool(forKey: "SHOW_CONTEXTUAL_MENU_FOR_SIDEBAR")
    }
    
    var showToolbarItemMenu: Bool {
        UserDefaults.group.bool(forKey: "SHOW_TOOLBAR_ITEM_MENU")
    }
}
