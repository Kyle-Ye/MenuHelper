//
//  SettingView.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        TabView {
            GeneralSettingTab()
                .tabItem { Label("General", systemImage: "wand.and.stars") }
            MenuSettingTab(store: MenuItemStore())
                .tabItem { Label("Menu", systemImage: "terminal") }
                .frame(height: 400)
            FolderSettingTab(store: FolderItemStore())
                .tabItem { Label("Folder", systemImage: "folder.badge.plus") }
                .frame(height: 400)
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
