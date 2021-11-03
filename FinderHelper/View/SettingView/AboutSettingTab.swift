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

    var body: some View {
        VStack {
            HStack {
                Text("Made by")
                Image("Kyle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                Text("[Kyle Ye](https://github.com/Kyle-Ye)")
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

struct AboutSettingTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutSettingTab()
    }
}
