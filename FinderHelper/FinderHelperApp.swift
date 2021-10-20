//
//  FinderHelperApp.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/27.
//

import SwiftUI

@main
struct FinderHelperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Settings {
            SettingView()
        }
    }
}

let channel = AppCommChannel()
