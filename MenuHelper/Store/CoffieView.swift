//
//  CoffieView.swift
//  MenuHelper
//
//  Created by Kyle on 2022/2/13.
//

import StoreKit
import SwiftUI

struct CoffieView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var store: Store
    @State private var errorTitle = ""
    @State private var isShowingError = false

    let coffie: Product
    let onPurchase: (Product) -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text(coffie.emojiName)
                .font(.system(size: 20))
            Text(coffie.description)
                .bold()
                .foregroundColor(Color.black)
                .clipShape(Rectangle())
                .padding(10)
                .background(Color.yellow)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
                .padding(.bottom, 5)
            buyButton
                .buttonStyle(BuyButtonStyle())
        }
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        })
    }

    var buyButton: some View {
        Button(action: {
            Task {
                await purchase()
            }
        }) {
            Text(coffie.displayPrice)
                .foregroundColor(.white)
                .bold()
        }
    }

    @MainActor
    func purchase() async {
        do {
            if try await store.purchase(coffie) != nil {
                onPurchase(coffie)
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed fuel purchase: \(error)")
        }
    }
}

extension Product {
    var emojiName: String {
        switch displayName {
        case let name where name.contains("lollipop") || name.contains("辣条"): return "🍭"
        case let name where name.contains("milk") || name.contains("牛奶"): return "🥛"
        case let name where name.contains("beer") || name.contains("啤酒"): return "🍺"
        case let name where name.contains("noodle") || name.contains("面条"): return "🍜"
        default: return displayName
        }
    }
}

struct BuyButtonStyle: ButtonStyle {
    let isPurchased: Bool

    init(isPurchased: Bool = false) {
        self.isPurchased = isPurchased
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        var bgColor: Color = isPurchased ? Color.green : Color.blue
        bgColor = configuration.isPressed ? bgColor.opacity(0.7) : bgColor.opacity(1)

        return configuration.label
            .frame(width: 70)
            .padding(10)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
