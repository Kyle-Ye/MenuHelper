//
//  SettingView.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        TabView{
            ActionSettingTab(store: AppMenuItemStore())
            FolderSettingTab()
            AboutSettingTab()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
