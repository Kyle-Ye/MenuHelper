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

    @State var item: AppMenuItem
    @State private var argumentString: String = ""
    @State private var environmentString: String = ""
    var index: Int?

    var body: some View {
        VStack {
            HStack {
                Text(item.appName).font(.title)

                Image(nsImage: item.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            HStack {
                Text("Enable:")
                Checkmark(isOn: item.enabled)
                    .onTapGesture { item.enabled.toggle() }
                Spacer()
            }
            HStack {
                Text("Display Name") + Text(":")
                TextField("Display Name", text: $item.itemName)
            }
            HStack {
                Toggle("Inherit from global arguments:", isOn: $item.inheritFromGlobalArguments)
                    .toggleStyle(.switch)
                Spacer()
            }
            VStack {
                HStack {
                    Text("Arguments") + Text(":")
                    TextField("Arguments", text: $argumentString)
                }
                Text("Format: \("-a -b --help")").font(.footnote).foregroundColor(.secondary)
            }
            HStack {
                Toggle("Inherit from global environment:", isOn: $item.inheritFromGlobalEnvironment)
                    .toggleStyle(.switch)
                Spacer()
            }
            VStack {
                HStack {
                    Text("Environment") + Text(":")
                    TextField("Environment", text: $environmentString)
                        .onSubmit {
                            let environment = environmentString.toDictionary()
                            environmentString = environment.toString()
                        }
                }
                Text("Format: \("KEY_A=0 KEY_B=1")").font(.footnote).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
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
                    Task {
                        item.arguments = argumentString.split(separator: " ").map { String($0) }
                        item.environment = environmentString.toDictionary()
                        store.updateAppItem(item: item, index: index)
                        dismiss()
                    }
                } label: {
                    Image(systemName: "checkmark.circle")
                }
            }
        }
        .onAppear {
            argumentString = item.arguments.joined(separator: " ")
            environmentString = item.environment.toString()
        }
    }
}

struct AppMenuItemEditor_Previews: PreviewProvider {
    static var previews: some View {
        AppMenuItemEditor(item: AppMenuItem(bundleIdentifier: "com.apple.dt.Xcode")!)
            .environment(MenuItemStore())
    }
}
