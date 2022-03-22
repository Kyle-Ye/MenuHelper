//
//  AppMenuItemView.swift
//  MenuHelper
//
//  Created by KyleYe on 2022/3/22.
//

import SwiftUI

struct AppMenuItemView: View {
    @EnvironmentObject var store: MenuItemStore
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
        .sheet(isPresented: $editingItem) {
            AppMenuItemEditor(item: item, index: store.appItems.firstIndex(of: item))
                .environmentObject(store)
        }
    }
}

struct AppMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        AppMenuItemView(item: .xcode!)
            .environmentObject(MenuItemStore())
    }
}
