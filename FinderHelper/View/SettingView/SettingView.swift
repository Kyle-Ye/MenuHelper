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
            ActionSettingTab(store: AppMenuItemStore())
                .tabItem { Label("Action", systemImage: "terminal") }
//            FolderSettingTab()
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
