//
//  AcknowledgementsWindow.swift
//  MenuHelper
//
//  Created by KyleYe on 2022/2/10.
//

import Foundation
import SwiftUI

struct AcknowledgementsWindow: View {
    private let licenses = [
        License(name: "Preferences", link: URL(string: "https://github.com/sindresorhus/Preferences/blob/main/license")!),
        License(name: "swift-collections", link: URL(string: "https://github.com/sindresorhus/Preferences/blob/main/license")!),
    ]
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                ForEach(licenses) {
                    Link($0.name, destination: $0.link)
                }
            }
        } header: {
            Text("Menu Helper is made possible with following projects:")
        } footer: {
            Text("Copyright ©️ 2022 YEXULEI. All rights reserved")
                .font(.footnote)
        }
    }
}

private struct License {
    init(name: String, link: URL) {
        self.name = name
        self.link = link
    }

    let name: String
    let link: URL
}

extension License: Identifiable {
    var id: String { name }
}
