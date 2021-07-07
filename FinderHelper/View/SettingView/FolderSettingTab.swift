//
//  FolderSettingTab.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct FolderSettingTab: View {
    var body: some View {
        AppMenuItemEditor(item: .constant(.vscode!))
            .tabItem { Label("Menu", systemImage: "folder.badge.plus") }
    }
}

struct FolderSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        FolderSettingTab()
    }
}
