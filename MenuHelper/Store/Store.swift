//
//  Store.swift
//  MenuHelper
//
//  Created by Kyle on 2022/2/13.
//

import Foundation
import StoreKit
import SwiftUI

typealias Transaction = StoreKit.Transaction

enum StoreError: Error {
    case failedVerification
}

class Store: ObservableObject {
    @Published private(set) var coffies: [Product] = []
    @Published private(set) var purchased = false
    var updateListenerTask: Task<Void, Error>?

    private let storage = NSUbiquitousKeyValueStore.default
    private static let purchasedKey = "PURCHASED"

    private let productIdentifiers = [
        "consumable.coffie.price1",
        "consumable.coffie.price2",
        "consumable.coffie.price3",
    ]

    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    // Deliver content to the user.
                    await self.updatePurchasedIdentifiers(transaction)
                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }

    @MainActor func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: productIdentifiers)
            coffies = storeProducts.filter { $0.type == .consumable }.sorted(by: \.price)
        } catch {
            print("Failed product request: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        switch result {
        case let .success(verification):
            let transaction = try checkVerified(verification)
            // Deliver content to the user.
            await updatePurchasedIdentifiers(transaction)
            // Always finish a transaction.
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case let .verified(safe):
            // If the transaction is verified, unwrap and return it.
            return safe
        }
    }

    @MainActor func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        if transaction.revocationDate == nil {
            // If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
            storage.set(true, forKey: Store.purchasedKey)
            purchased = true
        } else {
            // If the App Store has revoked this transaction, remove it from the list of `purchasedIdentifiers`.
            storage.set(false, forKey: Store.purchasedKey)
            purchased = false
        }
    }

    @MainActor func refreshPurchased() async {
        purchased = storage.bool(forKey: Store.purchasedKey)
    }
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}
