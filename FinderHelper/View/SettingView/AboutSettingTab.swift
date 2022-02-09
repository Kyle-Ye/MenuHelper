//
//  AboutSettingTab.swift
//  FinderHelper
//
//  Created by Kyle on 2021/6/29.
//

import Preferences
import SwiftUI

struct AboutSettingTab: View {
    private let contentWidth: Double = 450.0

    @State var redacted = true
    var body: some View {
        VStack {
            HStack {
                Text("Made by")
                Link(destination: URL(string: "https://github.com/Kyle-Ye")!) {
                    Image("Kyle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .onHover { redacted = !$0 }
                        .if(redacted) { $0.redacted(reason: .placeholder) }
                }
                Text("with 🥰")
            }
            Text("Inspired by [SwiftyMenu](https://apps.apple.com/cn/app/swiftymenu/id1567748223?l=en&mt=12) [Shengang Tang](https://twitter.com/lexrus)")
                .font(.footnote)
        }
        .font(.title)
        .frame(width: CGFloat(contentWidth), alignment: .center)
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct AboutSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingTab()
    }
}
