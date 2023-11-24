//
//  AppMenuItemEditor.swift
//  MenuHelper
//
//  Created by KyleYe on 2022/3/22.
//

import SwiftUI

struct AppMenuItemEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(MenuItemStore.self) private var store

    @State private var item: AppMenuItem
    private let result: Binding<AppMenuItem>

    private var itemArgumentBinding: Binding<String> {
        Binding<String> {
            item.arguments.joined(separator: " ")
        } set: { newValue in
            item.arguments = newValue.split(separator: " ").map { String($0) }
        }
    }

    private var itemEnvironmentBinding: Binding<String> {
        Binding<String> {
            item.environment.toString()
        } set: { newValue in
            item.environment = newValue.toDictionary()
        }
    }

    init(item: Binding<AppMenuItem>) {
        self._item = State(wrappedValue: item.wrappedValue)
        result = item
    }

    var body: some View {
        Form {
            HStack {
                Toggle(isOn: $item.enabled) {
                    Text(item.appName).font(.title)
                }.toggleStyle(.button)
                Spacer()
                Image(nsImage: item.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            Section {
                TextField(
                    text: $item.itemName,
                    axis: .horizontal
                ) {
                    Text("Display Name")
                }
            }
            Section {
                Toggle("Inherit from global arguments:", isOn: $item.inheritFromGlobalArguments)

                TextField(
                    text: itemArgumentBinding,
                    prompt: Text(verbatim: "-a -b --help"),
                    axis: .horizontal
                ) {
                    Text("Arguments")
                }
            }
            Section {
                Toggle("Inherit from global environment:", isOn: $item.inheritFromGlobalEnvironment)
                TextField(
                    text: itemEnvironmentBinding,
                    prompt: Text(verbatim: "KEY_A=0 KEY_B=1"),
                    axis: .horizontal
                ) {
                    Text("Environment")
                }
            }
        }
        .controlSize(.large)
        .formStyle(.grouped)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    result.wrappedValue = item
                    dismiss()
                } label: {
                    Image(systemName: "checkmark.circle")
                }
            }
        }
    }
}

#Preview {
    struct EditorPreview: View {
        @State private var store = MenuItemStore()
        @State private var item = AppMenuItem.xcode!
        var body: some View {
            AppMenuItemEditor(item: $item)
                    .environment(store)
        }
    }
    return EditorPreview()
}
