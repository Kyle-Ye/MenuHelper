//
//  SettingView.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        TabView {
            GeneralSettingTab()
                .tabItem { Label("General", systemImage: "wand.and.stars") }
            ActionSettingTab(store: MenuItemStore())
                .tabItem { Label("Action", systemImage: "terminal") }
            FolderSettingTab()
                .tabItem { Label("Menu", systemImage: "folder.badge.plus") }
            AboutSettingTab()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
