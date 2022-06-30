//
//  ContentView.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/27.
//

import os.log
import SwiftUI

private let logger = Logger(subsystem: subsystem, category: "main")

struct ContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image("icon")
            Text("You can turn on MenuHelper's extension in **System Settings -> Privacy & Security -> Extensions -> Added Extensions**")
                .multilineTextAlignment(.center)
            Button {
                // See this post https://stackoverflow.com/questions/24701362/os-x-system-preferences-url-scheme
                // Since Extensions.prefPane is not allowed to open via x-apple.systempreferences
                // let url = URL(string: "x-apple.systempreferences:com.apple.preferences.extensions")!
                // I have to manully use hard-coded url path
                // let url = URL(fileURLWithPath: "/System/Library/PreferencePanes/Extensions.prefPane")
                
                // Update macOS 13
                // /System/Library/PreferencePanes/Extensions.prefPane is ignored and we can use Security to replace it.
                let url = URL(fileURLWithPath: "/System/Library/PreferencePanes/Security.prefPane")
                
                let config = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.open(url, configuration: config) { _, error in
                    if let error = error {
                        logger.error("\(error.localizedDescription)")
                        return
                    }
                    DispatchQueue.main.async {
                        logger.notice("Terminate App")
                        NSApplication.shared.terminate(nil)
                    }
                }
            } label: {
                Text("Quit and Open System Settings...")
            }
            Button {
                logger.notice("Open Preferences Panel")
                NSApplication.shared.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            } label: {
                Text("Open Settings Panel...")
            }
        }.frame(width: 425, height: 325)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
