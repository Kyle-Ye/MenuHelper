//
//  AboutSettingTab.swift
//  MenuHelper
//
//  Created by Kyle on 2021/6/29.
//

import Preferences
import SwiftUI

struct AboutSettingTab: View {
    private let contentWidth: Double = 400
    @State private var rainbow = false

    var body: some View {
        VStack {
            HStack {
                Text("Made by")
                Link(destination: URL(string: "https://github.com/Kyle-Ye")!) {
                    ZStack {
                        Image("Kyle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .opacity(0.5)
                        Image("Kyle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .rainbowGlow()
                            .opacity(rainbow ? 1 : 0)
                            .animation(.default, value: rainbow)
                    }
                    .onHover { rainbow = $0 }
                }
                Text("with 🥰")
            }
            (
                Text("Inspired by") +
                    Text(try! AttributedString(markdown: " [SwiftyMenu](https://apps.apple.com/cn/app/swiftymenu/id1567748223) [Lex Tang](https://twitter.com/lexrus)"))
            )
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
    @ViewBuilder func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }

    func rainbowGlow() -> some View {
        ZStack {
            ForEach(0 ..< 2) { i in
                Rectangle()
                    .fill(AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center))
                    .frame(width: 80, height: 80)
                    .mask(blur(radius: 8))
                    .overlay(blur(radius: 5 - CGFloat(i * 5)))
            }
        }
    }
}

struct AboutSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingTab()
    }
}
