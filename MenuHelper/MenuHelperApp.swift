//
//  MenuHelperApp.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/27.
//

import SwiftUI

@main
struct MenuHelperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        WindowGroup("Acknowledgements") {
            AcknowledgementsWindow()
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "acknowledgements"))
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Acknowledgements..") {
                    guard let url = URL(string: "menu-helper://acknowledgements") else { return }
                    NSWorkspace.shared.open(url)
                }
            }
            CommandGroup(replacing: .newItem) {}
        }
        Settings {
            SettingView()
        }
    }
}

let channel = AppCommChannel()
