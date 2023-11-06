//
//  CoffieStoreView.swift
//  MenuHelper
//
//  Created by Kyle on 2022/2/13.
//

import StoreKit
import SwiftUI

struct CoffieStoreView: View {
    @Environment(Store.self) var store
    let coffies: [Product]
    let onPurchase: (Product) -> Void

    var body: some View {
        VStack {
            Text("If you feel this app is useful for you, please consider supporting me")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                if !store.purchased {
                    Link(destination: URL(string: "https://github.com/Kyle-Ye")!) {
                        Image("Kyle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .rainbowGlow()
                    }
                    Text("Thanks for your supporting")
                }
            }
            HStack {
                ForEach(coffies, id: \.id) { coffie in
                    CoffieView(coffie: coffie, onPurchase: onPurchase)
                }
            }
        }
        .onAppear {
            Task {
                await store.refreshPurchased()
            }
        }
    }
}

struct CoffieStoreView_Previews: PreviewProvider {
    static var previews: some View {
        CoffieStoreView(coffies: []) {
            print($0.displayName + $0.displayPrice)
        }
        .environment(Store())
    }
}
