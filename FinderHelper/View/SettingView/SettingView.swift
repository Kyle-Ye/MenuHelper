//
//  SettingView.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI
// import Preferences

struct SettingView: View {
    var body: some View {
        TabView {
//            Preferences.Container(contentWidth: 450.0) {
//                Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
//                    Text("Actions")
//                } content: {
//                    List {
//                        ForEach(0 ..< 5) { index in
//                            Text("\(index)")
//                        }
//                        .onInsert(of: [.fileURL]) { _, _ in
//                        }
//                    }
//                }
//            }
//
//            .tabItem { Label("General", systemImage: "wand.and.stars") }
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
