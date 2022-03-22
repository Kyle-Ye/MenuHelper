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

    var body: some View {
        VStack {
            Text(item.appName)
            HStack {
                Text("Display Name:")
                TextField("Display Name", text: $item.itemName)
            }
        }
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
                    store.updateAppItem(item: item)
                    dismiss()
                }
            } label: {
                Image(systemName: "checkmark.circle")
            }
        }
    }
}

struct AppMenuItemEditor_Previews: PreviewProvider {
    static var previews: some View {
        AppMenuItemEditor(item: AppMenuItem(bundleIdentifier: "com.apple.dt.Xcode")!)
            .environmentObject(MenuItemStore())
    }
}
