//
//  GeneralSettingTab.swift
//  GeneralSettingTab
//
//  Created by Kyle on 2021/10/9.
//

import Preferences
import SwiftUI

struct GeneralSettingTab: View {
    @AppStorage("SHOW_CONTEXTUAL_MENU_FOR_ITEM", store: .group)
    private var showContextualMenuForItem = true
    @AppStorage("SHOW_CONTEXTUAL_MENU_FOR_CONTAINER", store: .group)
    private var showContextualMenuForContainer = true
    @AppStorage("SHOW_CONTEXTUAL_MENU_FOR_SIDEBAR", store: .group)
    private var showContextualMenuForSidebar = true
    @AppStorage("SHOW_TOOLBAR_ITEM_MENU", store: .group)
    private var showToolbarItemMenu = true
    
    var body: some View {
        Preferences.Container(contentWidth: 450) {
            Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
                Text("Locations:")
            } content: {
                Toggle(isOn: $showToolbarItemMenu) { Text("Show in toolbar item menu") }
                Toggle(isOn: $showContextualMenuForItem) { Text("Show in contextual menu for item") }
                Toggle(isOn: $showContextualMenuForContainer) { Text("Show in contextual menu for container") }
                Toggle(isOn: $showContextualMenuForSidebar) { Text("Show in contextual menu for sidebar") }
            }
        }
    }
}

struct GeneralSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingTab()
    }
}
