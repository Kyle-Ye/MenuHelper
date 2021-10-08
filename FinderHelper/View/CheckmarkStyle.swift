//
//  CheckmarkToggleStyle.swift
//  CheckmarkStyle
//
//  Created by Kyle on 2021/10/8.
//

import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: "checkmark")
                .symbolVariant(.circle)
                .symbolVariant(configuration.isOn ? .fill : .none)
                .foregroundColor(.accentColor)
            configuration.label
        }
        .onTapGesture {
            withAnimation(.spring()) {
                configuration.isOn.toggle()
            }
        }
    }
}

extension ToggleStyle where Self == CheckmarkToggleStyle {
    static var checkmark: CheckmarkToggleStyle {
        CheckmarkToggleStyle()
    }
}

struct CheckmarkToggleStyle_Previews: PreviewProvider {
//    static var isOn = true
    static var previews: some View {
        VStack {
            Toggle(isOn: .constant(true)) {
                Text("Test")
            }.toggleStyle(.checkmark)

            Toggle(isOn: .constant(false)) {
                Text("Test")
            }.toggleStyle(.checkmark)
        }
        .background(.background)
        .preferredColorScheme(.light)
        VStack {
            Toggle(isOn: .constant(true)) {
                Text("Test")
            }.toggleStyle(.checkmark)

            Toggle(isOn: .constant(false)) {
                Text("Test")
            }.toggleStyle(.checkmark)
        }
        .background(.background)
        .preferredColorScheme(.dark)
    }
}
