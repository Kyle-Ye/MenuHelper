//
//  SettingView.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct SettingView: View {
    @State var menuItemStore = MenuItemStore()
    @State var folderItemStore = FolderItemStore()

    var body: some View {
        TabView {
            GeneralSettingTab(menuItemStore: menuItemStore)
                .tabItem { Label("General", systemImage: "wand.and.stars") }
            MenuSettingTab(store: menuItemStore)
                .tabItem { Label("Menu", systemImage: "terminal") }
                .frame(height: 400)
            FolderSettingTab(store: folderItemStore)
                .tabItem { Label("Folder", systemImage: "folder.badge.plus") }
                .frame(height: 400)
            AboutSettingTab()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
    }
}

#Preview {
    SettingView()
}
