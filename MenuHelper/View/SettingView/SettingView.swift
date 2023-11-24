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
                .frame(width: 500, height: 400)
            MenuSettingTab(store: menuItemStore)
                .tabItem { Label("Menu", systemImage: "terminal") }
                .frame(width: 500, height: 400)
            FolderSettingTab(store: folderItemStore)
                .tabItem { Label("Folder", systemImage: "folder.badge.plus") }
                .frame(width: 500, height: 400)
            AboutSettingTab()
                .tabItem { Label("About", systemImage: "info.circle") }
                .frame(width: 400, height: 200)
        }
    }
}

#Preview {
    SettingView()
}
