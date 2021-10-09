//
//  FinderSync+UserDefaults.swift
//  FinderSync+UserDefaults
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
    
    var storeNeedUpdate: Bool {
        get {
            UserDefaults.group.bool(forKey: "STORE_NEED_UPDATE")
        }
        set {
            UserDefaults.group.set(newValue, forKey: "STORE_NEED_UPDATE")
        }
    }
}
