//
//  Checkmakr.swift
//  CheckmarkStyle
//
//  Created by Kyle on 2021/10/8.
//

import SwiftUI

struct Checkmark: View {
    var isOn: Bool

    var body: some View {
        Image(systemName: "checkmark")
            .symbolVariant(.circle)
            .symbolVariant(isOn ? .fill : .none)
            .font(.title)
            .foregroundColor(.accentColor)
    }
}

struct Checkmark_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Checkmark(isOn: true)
            Checkmark(isOn: false)
        }
        .background(.background)
        .preferredColorScheme(.light)
        VStack {
            Checkmark(isOn: true)
            Checkmark(isOn: false)
        }
        .background(.background)
        .preferredColorScheme(.dark)
    }
}
