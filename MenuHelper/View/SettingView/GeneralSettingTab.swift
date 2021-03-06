//
//  GeneralSettingTab.swift
//  GeneralSettingTab
//
//  Created by Kyle on 2021/10/9.
//

import Preferences
import SwiftUI

struct GeneralSettingTab: View {
    @AppStorage(Key.showContextualMenuForItem)
    private var showContextualMenuForItem = true
    @AppStorage(Key.showContextualMenuForContainer)
    private var showContextualMenuForContainer = true
    @AppStorage(Key.showContextualMenuForSidebar)
    private var showContextualMenuForSidebar = true
    @AppStorage(Key.showToolbarItemMenu)
    private var showToolbarItemMenu = true

    @AppStorage(Key.globalApplicationArgumentsString)
    private var globalApplicationArgumentsString = ""
    @AppStorage(Key.globalApplicationEnvironmentString)
    private var globalApplicationEnvironmentString = ""

    @AppStorage(Key.copyPathSeparator)
    private var copyPathSeparator = ""
    @AppStorage(Key.copyPathOption)
    private var copyPathOption = CopyPathOption.escape
    @AppStorage(Key.newFileName)
    private var newFileName = ""
    @AppStorage(Key.newFileExtension)
    private var newFileExtension = NewFileExtension.none

    @ObservedObject var menuItemStore: MenuItemStore

    private var hasCopyPath: Bool { menuItemStore.actionItems.contains(ActionMenuItem.copyPath) }
    private var hasNewFile: Bool { menuItemStore.actionItems.contains(ActionMenuItem.newFile) }

    var body: some View {
        Preferences.Container(contentWidth: 600) {
            Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
                EmptyView()
            } content: {
                Section {
                    HStack {
                        Toggle(isOn: $showToolbarItemMenu) { Text("Clicks on the extension’s toolbar button.") }
                        Text("*(Custom toolbar in Finder to show/hide this app in Finder toolbar)*").font(.footnote)
                    }
                    Toggle(isOn: $showContextualMenuForItem) { Text("Control-clicks on an item or a group of selected items inside the Finder window.") }
                    Toggle(isOn: $showContextualMenuForContainer) { Text("Control-clicks on the Finder window’s background.") }
                    HStack {
                        Toggle(isOn: $showContextualMenuForSidebar) { Text("Control-clicks on an item in the sidebar.") }
                        Text("*(Unavailable since macOS Big Sur)*").font(.footnote)
                    }
                } header: {
                    Text("Display Settings:") + Text("(When to show related menus)").font(.footnote)
                } footer: {
                    Text("Right-click is the same as control-click")
                        .font(.footnote)
                        .bold()
                }
            }
            Preferences.Section(bottomDivider: hasCopyPath, verticalAlignment: .top) {
                EmptyView()
            } content: {
                Section {
                    VStack {
                        HStack {
                            Text("Arguments:")
                            TextField("Arguments", text: $globalApplicationArgumentsString)
                        }
                        Text("Format: \("-a -b --help")").font(.footnote).foregroundColor(.secondary)
                    }
                    VStack {
                        HStack {
                            Text("Environment:")
                            TextField("Environment", text: $globalApplicationEnvironmentString)
                                .onSubmit {
                                    let environment = globalApplicationEnvironmentString.toDictionary()
                                    globalApplicationEnvironmentString = environment.toString()
                                }
                        }
                        Text("Format: \("KEY_A=0 KEY_B=1")").font(.footnote).foregroundColor(.secondary)
                    }
                } header: {
                    Text("Global Application Settings:")
                }
            }

            Preferences.Section(bottomDivider: hasNewFile, verticalAlignment: .top) {
                EmptyView()
            } content: {
                if hasCopyPath {
                    Section {
                        HStack {
                            HStack {
                                Text("Join-separator when multi items are seleted")
                                TextField(#"Default is " ""#, text: $copyPathSeparator)
                            }
                            Picker(selection: $copyPathOption, label: Text("Copy Style")) {
                                ForEach(CopyPathOption.allCases) { option in
                                    Text(option.description).tag(option)
                                }
                            }
                        }

                    } header: {
                        Text("Copy Path Settings:")
                    }
                }
            }
            Preferences.Section(bottomDivider: true, verticalAlignment: .top) {
                EmptyView()
            } content: {
                if hasNewFile {
                    Section {
                        HStack {
                            HStack {
                                Text("File Name")
                                TextField("Untitled", text: $newFileName)
                            }
                            Picker(selection: $newFileExtension, label: Text("File Extension")) {
                                ForEach(NewFileExtension.allCases) { fileExtension in
                                    Text(fileExtension.rawValue).tag(fileExtension)
                                }
                            }
                        }
                    } header: {
                        Text("New File Settings:")
                    }
                }
            }
        }
    }
}

struct GeneralSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingTab(menuItemStore: MenuItemStore())
    }
}
