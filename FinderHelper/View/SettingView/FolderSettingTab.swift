//
//  FolderSettingTab.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import Preferences
import SwiftUI

struct FolderSettingTab: View {
    var body: some View {
        Preferences.Container(contentWidth: 450) {
            Preferences.Section {
                Text("TODO:")
            } content: {
               Text("TODO")
            }
        }
    }
}

struct FolderSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        FolderSettingTab()
    }
}
