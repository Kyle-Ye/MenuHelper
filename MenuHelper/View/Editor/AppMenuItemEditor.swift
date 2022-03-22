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
                TextField("Display Name:", text: $item.itemName)
            }
            Text("Arguments:")
            List {
                Button {
                    item.arguments.append("")
                } label: {
                    Text("Add argument")
                }

                ForEach($item.arguments, id: \.self) { $argument in
                    TextField("argument", text: $argument)
                }
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
                    store.updateAppItem(item: item, index: index)
                    dismiss()
                }
            } label: {
                Image(systemName: "checkmark.circle")
            }
        }
    }
}

// struct AppMenuItemEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        AppMenuItemEditor(item: AppMenuItem(bundleIdentifier: "com.apple.dt.Xcode")!)
//            .environmentObject(MenuItemStore())
//    }
// }
