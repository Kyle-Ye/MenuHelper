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
        HStack {
            Text("Made by")
            Image("Kyle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            Text("with 🥰")
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
