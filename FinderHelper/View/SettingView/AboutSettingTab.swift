//
//  AboutSettingTab.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct AboutSettingTab: View {
    var body: some View {
        AppMenuItemEditor(item: .constant(.vscode!))
            .tabItem { Label("About", systemImage: "info.circle") }
    }
}

struct AboutSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingTab()
    }
}
