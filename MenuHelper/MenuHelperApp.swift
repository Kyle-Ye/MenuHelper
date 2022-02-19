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
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        WindowGroup("Acknowledgements") {
            AcknowledgementsWindow()
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "acknowledgements"))
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Acknowledgements...") {
                    guard let url = URL(string: "menu-helper://acknowledgements") else { return }
                    NSWorkspace.shared.open(url)
                }
            }
        }
        WindowGroup("Support") {
            SupportWindow()
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "support"))
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Support Author...") {
                    guard let url = URL(string: "menu-helper://support") else { return }
                    NSWorkspace.shared.open(url)
                }
            }
        }
        Settings {
            SettingView()
        }
        .defaultAppStorage(.group)
    }
}

let channel = AppCommChannel()
