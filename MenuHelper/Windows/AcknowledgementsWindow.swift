//
//  AcknowledgementsWindow.swift
//  MenuHelper
//
//  Created by KyleYe on 2022/2/10.
//

import Foundation
import SwiftUI
import AcknowKit

struct AcknowledgementsWindow: View {
    var body: some View {
        NavigationStack {
            AcknowLibraryForm(library: library)
        }
    }
    private let library = AcknowLibrary(
        items: [
            .swiftCollections,
            .acknowKit,
        ],
        header: "Menu Helper is made possible with following projects",
        footer: "Copyright ©️ 2023 YEXULEI. All rights reserved"
    )
}

extension AcknowLibrary.Item {
    static let swiftCollections = AcknowLibrary.Item(
        title: "swift-collections",
        author: "Apple",
        license: .apache,
        repository: URL(string: "https://github.com/apple/swift-collections")
    )

    static let acknowKit = AcknowLibrary.Item(
        title: "AcknowKit",
        text: #"""
        MIT License

        Copyright (c) 2023 Kyle-Ye

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE
        """#,
        author: "Kyle-Ye",
        license: .mit,
        repository: URL(string: "https://github.com/Kyle-Ye/AcknowKit")
    )
}

#Preview {
    AcknowledgementsWindow()
}
