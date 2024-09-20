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
    private var enable: Bool {
        FIFinderSyncController.isExtensionEnabled
    }

    private var imageName: String {
        enable ? "gear.badge.checkmark" : "gear.badge.xmark"
    }

    private var hint: LocalizedStringKey {
        enable
        ? "You can turn off MenuHelper's extension in **System Settings -> Privacy & Security -> Extensions -> Added Extensions**"
        : "You can turn on MenuHelper's extension in **System Settings -> Privacy & Security -> Extensions -> Added Extensions**"
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .symbolRenderingMode(.multicolor)
                    Text(hint)
                        .multilineTextAlignment(.leading)
                }
            } header: {
                HStack {
                    Spacer()
                    Image("icon")
                    Spacer()
                }
            }
            Section {
                Button {
                    FIFinderSyncController.showExtensionManagementInterface()
                } label: {
                    Text("Open System Extension Panel...")
                }
                SettingsLink {
                    Text("Open App Settings Window...")
                }
                Button {
                    MenuItemStore.migrateFromOldUserDefaults()
                    FolderItemStore.migrateFromOldUserDefaults()
                } label: {
                    Text("Migrate from old UserDefaults")
                }
            }
            .buttonStyle(.link)
            .foregroundStyle(.accent)
        }
        .formStyle(.grouped)
        .scrollBounceBehavior(.basedOnSize)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
