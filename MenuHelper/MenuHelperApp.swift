//
//  MenuHelperApp.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/27.
//

import SwiftUI

@main
struct MenuHelperApp: App {
    @Environment(\.openWindow) var openWindow

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 600, height: 400)
        .defaultPosition(.center)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        
        Window("Acknowledgements", id: "acknowledgements") {
            AcknowledgementsWindow()
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "acknowledgements"))
        .commands {
            CommandGroup(after: .appSettings) {
                Button {
                    openWindow(id: "acknowledgements")
                } label: {
                    Text("Acknowledgements") + Text(verbatim: "...")
                }
            }
        }
        .defaultSize(width: 400, height: 200)
        
        Window("Support", id: "support") {
            SupportWindow()
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "support"))
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Support Author...") {
                    openWindow(id: "support")
                }
            }
        }
        .defaultPosition(.center)
        .defaultSize(width: 500, height: 300)
        
        Settings {
            SettingView()
        }
        .defaultAppStorage(.group)
    }
}

let channel = AppCommChannel()

