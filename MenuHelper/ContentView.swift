//
//  ContentView.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/27.
//

import FinderSync
import os.log
import SwiftUI

private let logger = Logger(subsystem: subsystem, category: "main")

struct ContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image("icon")
            Text("You can turn on MenuHelper's extension in **System Settings -> Privacy & Security -> Extensions -> Added Extensions**")
                .multilineTextAlignment(.center)
            // FIXME: FIFinderSyncController.isExtensionEnabled is always returning false now.
            // Hide the related UI and add text description if extension is enabled.
            if !FIFinderSyncController.isExtensionEnabled {
                Button {
                    FIFinderSyncController.showExtensionManagementInterface()
                } label: {
                    Text("Open System Extension Panel...")
                }
            }
            SettingsLink {
                Text("Open App Settings Window...")
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
