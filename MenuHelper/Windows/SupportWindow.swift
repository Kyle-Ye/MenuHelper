//
//  SupportWindow.swift
//  MenuHelper
//
//  Created by Kyle on 2022/2/13.
//

import Foundation
import SwiftUI

struct SupportWindow: View {
    @State var store = Store()

    var body: some View {
        CoffieStoreView(coffies: store.coffies) { _ in }
            .environment(store)
    }
}

struct SupportWindow_Previews: PreviewProvider {
    static var previews: some View {
        SupportWindow()
    }
}
