//
//  ActionSettingTab.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import SwiftUI

struct ActionSettingTab: View {
    @AppStorage("SHOW_TOOLBAR_MENU", store: .standard)
    private var showToolbarMenu = true
    @AppStorage("SHOW_CONTEXTUAL_MENU", store: .standard)
    private var showContextualMenu = true

    @ObservedObject var store: AppMenuItemStore
    @State private var editItem = false

    var body: some View {
        VStack {
            HStack {
                Toggle(isOn: $showContextualMenu) {
                    Text("Show in contextual menu")
                }
                Toggle(isOn: $showToolbarMenu) {
                    Text("Show in toolbar menu")
                }
            }
            List {
                ForEach($store.items, id: \.url.path) { $item in
                    HStack {
                        Image(nsImage: item.icon)
                        Text(item.name)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            editItem = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }

                        Button(role: .destructive) {
                            guard let index = store.items.firstIndex(of: item) else { return }
                            store.items.remove(at: index)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    // BUG TOBEFIX
                    .sheet(isPresented: $editItem) {
                        editItem = false
                    } content: {
                        AppMenuItemEditor(item: $item)
                    }
                }
            }
        }
        .tabItem { Label("Action", systemImage: "terminal") }
    }
}

struct ActionSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        ActionSettingTab(store: AppMenuItemStore())
    }
}
