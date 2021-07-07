//
//  AppMenuItemEditor.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct AppMenuItemEditor: View {
    @Environment(\.dismiss) var dismiss
    @Binding var item: AppMenuItem

    var body: some View {
        Form {
            Image(nsImage: item.icon)
                .alignmentGuide(.leading) { d in
                    d.width
                }
            TextField(text: $item.itemName, prompt: Text(item.appName)) {
                Text("Name")
            }

            HStack {
                TextField(text: .constant(item.url.path), prompt: nil) {
                    Text("Path")
                }
                .disabled(true)
                Button {
                    selectApp()
                } label: {
                    Text("Select")
                }
            }
        }
        .padding()
        .overlay(Image(systemName: "xmark.circle.fill")
            .onTapGesture { dismiss() }, alignment: .topTrailing)
    }

    private func selectApp() {
        let appPicker = NSOpenPanel()
        appPicker.canChooseDirectories = false
        appPicker.canChooseFiles = true
        appPicker.allowsMultipleSelection = false
        appPicker.resolvesAliases = true
        appPicker.beginSheetModal(for: NSApplication.shared.keyWindow!) { response in
            if response == .OK {
                if let url = appPicker.url {
                    item.url = url
                }
            }
        }
    }
}

struct AppMenuItemEditor_Previews: PreviewProvider {
    static var previews: some View {
        AppMenuItemEditor(item: .constant(.vscode!))
    }
}
