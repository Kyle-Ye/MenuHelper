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
        Preferences.Container(contentWidth: 600) {
            Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
                EmptyView()
            } content: {
                Section {
                    HStack {
                        Toggle(isOn: $showToolbarItemMenu) { Text("Clicks on the extension’s toolbar button.") }
                        Text("*(Custom toolbar in Finder to show/hide this app in Finder toolbar)*").font(.footnote)
                    }
                    Toggle(isOn: $showContextualMenuForItem) { Text("Control-clicks on an item or a group of selected items inside the Finder window.") }
                    Toggle(isOn: $showContextualMenuForContainer) { Text("Control-clicks on the Finder window’s background.") }
                    HStack {
                        Toggle(isOn: $showContextualMenuForSidebar) { Text("Control-clicks on an item in the sidebar.") }
                        Text("*(Unavailable since macOS Big Sur)*").font(.footnote)
                    }
                } header: {
                    Text("Menu Settings (When to show related menus)")
                } footer: {
                    Text("Right-click is the same as control-click")
                        .font(.footnote)
                        .bold()
                }
            }
        }
    }
}

struct GeneralSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingTab()
    }
}
