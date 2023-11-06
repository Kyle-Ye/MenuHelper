//
//  AppMenuItemView.swift
//  MenuHelper
//
//  Created by KyleYe on 2022/3/22.
//

import SwiftUI

struct AppMenuItemView: View {
    @Environment(MenuItemStore.self) var store
    @State private var editingItem = false
    var item: AppMenuItem

    var body: some View {
        HStack {
            HStack {
                Checkmark(isOn: item.enabled)
                Image(nsImage: item.icon)
                Text(item.name)
            }.onTapGesture {
                store.toggleItem(item)
            }
            Button {
                editingItem = true
            } label: {
                Image(systemName: "pencil").foregroundColor(.accentColor)
            }
        }
        .sheet(isPresented: $editingItem, onDismiss: nil) {
            AppMenuItemEditor(item: item, index: store.appItems.firstIndex(of: item))
                .environment(store)
        }
    }
}

struct AppMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        AppMenuItemView(item: .xcode!)
            .environment(MenuItemStore())
    }
}
