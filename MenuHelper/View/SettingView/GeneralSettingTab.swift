//
//  GeneralSettingTab.swift
//  GeneralSettingTab
//
//  Created by Kyle on 2021/10/9.
//

import SwiftUI

@Observable
class GeneralSettingTabState {
    var showContextualMenuForItem: Bool {
        get {
            access(keyPath: \.showContextualMenuForItem)
            return UserDefaults.group.bool(forKey: Key.showContextualMenuForItem)
        }
        set {
            withMutation(keyPath: \.showContextualMenuForItem) {
                UserDefaults.group.setValue(newValue, forKey: Key.showContextualMenuForItem)
            }
        }
    }

    var showContextualMenuForContainer: Bool {
        get {
            access(keyPath: \.showContextualMenuForContainer)
            return UserDefaults.group.bool(forKey: Key.showContextualMenuForContainer)
        }
        set {
            withMutation(keyPath: \.showContextualMenuForContainer) {
                UserDefaults.group.setValue(newValue, forKey: Key.showContextualMenuForContainer)
            }
        }
    }

    var showContextualMenuForSidebar: Bool {
        get {
            access(keyPath: \.showContextualMenuForSidebar)
            return UserDefaults.group.bool(forKey: Key.showContextualMenuForSidebar)
        }
        set {
            withMutation(keyPath: \.showContextualMenuForSidebar) {
                UserDefaults.group.setValue(newValue, forKey: Key.showContextualMenuForSidebar)
            }
        }
    }

    var showToolbarItemMenu: Bool {
        get {
            access(keyPath: \.showToolbarItemMenu)
            return UserDefaults.group.bool(forKey: Key.showToolbarItemMenu)
        }
        set {
            withMutation(keyPath: \.showToolbarItemMenu) {
                UserDefaults.group.setValue(newValue, forKey: Key.showToolbarItemMenu)
            }
        }
    }
}

struct GeneralSettingTab: View {
    @AppStorage(Key.globalApplicationArgumentsString)
    private var globalApplicationArgumentsString = ""
    @AppStorage(Key.globalApplicationEnvironmentString)
    private var globalApplicationEnvironmentString = ""

    @AppStorage(Key.copySeparator)
    private var copySeparator = ""
    @AppStorage(Key.copyOption)
    private var copyOption = CopyOption.escape
    @AppStorage(Key.newFileName)
    private var newFileName = ""
    @AppStorage(Key.newFileExtension)
    private var newFileExtension = NewFileExtension.none

    var menuItemStore: MenuItemStore

    @State private var model = GeneralSettingTabState()

    private var shouldShowCopySection: Bool {
        guard let copyPath = menuItemStore.actionItems.first(where: { $0 == ActionMenuItem.copyPath }),
              let copyFileName = menuItemStore.actionItems.first(where: { $0 == ActionMenuItem.copyFileName })
        else { return false }
        return copyPath.enabled || copyFileName.enabled
    }

    private var shouldShowNewFileSection: Bool {
        guard let newFile = menuItemStore.actionItems.first(where: { $0 == ActionMenuItem.newFile })
        else { return false }
        return newFile.enabled
    }

    var body: some View {
        Form {
            displaySection
            applicationSection
            if shouldShowCopySection {
                copySection
            }
            if shouldShowNewFileSection {
                newFileSection
            }
        }
        .controlSize(.large)
        .formStyle(.grouped)
    }

    private var displaySection: some View {
        Section {
            Toggle(isOn: $model.showToolbarItemMenu) {
                Text("Clicks on the extension’s toolbar button.")
                    + Text("*(Custom toolbar in Finder to show/hide this app in Finder toolbar)*").font(.footnote)
            }
            Toggle("Control-clicks on an item or a group of selected items inside the Finder window.", isOn: $model.showContextualMenuForItem)
            Toggle("Control-clicks on the Finder window’s background.", isOn: $model.showContextualMenuForContainer)
            Toggle("Control-clicks on an item in the sidebar.", isOn: $model.showContextualMenuForSidebar)
        } header: {
            Text("Display Settings") + Text("(When to show related menus)").font(.footnote)
        } footer: {
            Text("Right-click is the same as control-click")
                .font(.footnote)
                .bold()
        }
    }

    // TODO: Add advanced GUI manager
    private var applicationSection: some View {
        Section {
            TextField(
                text: $globalApplicationArgumentsString,
                prompt: Text(verbatim: "-a -b --help"),
                axis: .horizontal
            ) {
                Text("Arguments")
            }
            TextField(
                text: $globalApplicationEnvironmentString,
                prompt: Text(verbatim: "KEY_A=0 KEY_B=1"),
                axis: .horizontal
            ) {
                Text("Environment")
            }
            .onSubmit {
                let environment = globalApplicationEnvironmentString.toDictionary()
                globalApplicationEnvironmentString = environment.toString()
            }
        } header: {
            Text("Global Application Settings")
        }
    }

    private var copySection: some View {
        Section {
            TextField(
                text: $copySeparator,
                prompt: Text(#"Default is " ""#),
                axis: .horizontal
            ) {
                Text("Join-separator when multi items are seleted")
            }
            Picker(selection: $copyOption, label: Text("Copy Style")) {
                ForEach(CopyOption.allCases) { option in
                    Text(option.description).tag(option)
                }
            }
        } header: {
            Text("Copy Settings")
        }
    }

    private var newFileSection: some View {
        Section {
            TextField(
                text: $newFileName,
                prompt: Text("Untitled"),
                axis: .horizontal
            ) {
                Text("File Name")
            }
            Picker(selection: $newFileExtension, label: Text("File Extension")) {
                ForEach(NewFileExtension.allCases) { fileExtension in
                    Text(fileExtension.rawValue).tag(fileExtension)
                }
            }
        } header: {
            Text("New File Settings:")
        }
    }
}

#Preview {
    GeneralSettingTab(menuItemStore: MenuItemStore())
}
