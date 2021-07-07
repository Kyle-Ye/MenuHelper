//
//  AppMenuItemStore.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

class AppMenuItemStore: ObservableObject {
    @Published var items: [AppMenuItem] = [.xcode, .vscode, .terminal].compactMap { $0 }

    func getAppURL(from appName: String) -> URL? {
        items.first { item in
            item.name == appName
        }?.url
    }
}
