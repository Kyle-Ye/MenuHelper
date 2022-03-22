//
//  AppMenuItemEditor.swift
//  MenuHelper
//
//  Created by KyleYe on 2022/3/22.
//

import SwiftUI

struct AppMenuItemEditor: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: MenuItemStore

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
                Toggle("Inherit from shared environment:", isOn: $item.inheritFromSharedEnvironment)
                    .toggleStyle(.switch)
                Spacer()
            }
            HStack {
                Text("Display Name:")
                TextField("Display Name", text: $item.itemName)
            }
            HStack {
                Text("Arguments:")
                TextField("Arguments", text: $argumentString)
            }
            HStack {
                Text("Environment:")
                TextField("Environment", text: $environmentString)
            }
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 300)
        .toolbar {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle")
            }
            Spacer()
            Button {
                Task {
                    item.arguments = argumentString.split(separator: " ").map { String($0) }
                    item.environment = environmentString.split(separator: " ")
                        .map { $0.split(separator: "=") }
                        .filter { $0.count == 2 }
                        .reduce(into: [String: String]()) { result, pair in
                            let key = String(pair[0])
                            let value = String(pair[1])
                            result[key] = value
                        }
                    store.updateAppItem(item: item, index: index)
                    dismiss()
                }
            } label: {
                Image(systemName: "checkmark.circle")
            }
        }
        .onAppear {
            argumentString = item.arguments.joined(separator: " ")
            environmentString = item.environment.compactMap { "\($0)=\($1)" }.joined(separator: " ")
        }
    }
}

struct AppMenuItemEditor_Previews: PreviewProvider {
    static var previews: some View {
        AppMenuItemEditor(item: AppMenuItem(bundleIdentifier: "com.apple.dt.Xcode")!)
            .environmentObject(MenuItemStore())
    }
}
