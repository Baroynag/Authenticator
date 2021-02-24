//
//  Purchases.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 08.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//
import StoreKit

enum PurchasesError: Error {
    case purchaseInProgress
    case productNotFound
    case unknown
}

class Purchases: NSObject {

    static let `default` = Purchases()

    private var productsRequestCallbacks = [(Result<[SKProduct], Error>) -> Void]()
    fileprivate var productPurchaseCallback: ((Result<Bool, Error>) -> Void)?
    private let productIdentifiers = Set<String>(
        arrayLiteral: "am.baroynag.SOTP.OneDollarDonation",
        "am.baroynag.SOTP.FiveDollarDonation"
    )

    private var productRequest: SKProductsRequest?
    public var products: [String: SKProduct]?

    func initialize(completion: @escaping (Result<[SKProduct], Error>) -> Void) {
        requestProducts(completion: completion)
    }

    private func requestProducts(completion: @escaping (Result<[SKProduct], Error>) -> Void) {
        guard productsRequestCallbacks.isEmpty else {
            productsRequestCallbacks.append(completion)
            return
        }

        productsRequestCallbacks.append(completion)

        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()

        self.productRequest = productRequest
    }

    func purchaseProduct(productId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        guard let product = products?[productId] else {
            completion(.failure(PurchasesError.productNotFound))
            return
        }

        productPurchaseCallback = completion

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }

}

extension Purchases: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
            guard !response.products.isEmpty else {
            productsRequestCallbacks.forEach { $0(.success(response.products)) }
            productsRequestCallbacks.removeAll()
            return
        }

        var products = [String: SKProduct]()
        for skProduct in response.products {
            products[skProduct.productIdentifier] = skProduct
        }

        self.products = products

        productsRequestCallbacks.forEach { $0(.success(response.products)) }
        productsRequestCallbacks.removeAll()
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCallbacks.forEach { $0(.failure(error)) }
        productsRequestCallbacks.removeAll()
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }

    var title: String? {
        switch productIdentifier {
        case "am.baroynag.SOTP.OneDollarDonation":
            return "One dollar donation"
        default:
            return nil
        }
    }
}

extension Purchases: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                if finishTransaction(transaction) {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                    productPurchaseCallback?(.success(true))
                } else {
                    productPurchaseCallback?(.failure(PurchasesError.unknown))
                }

            case .failed:
                productPurchaseCallback?(.failure(transaction.error ?? PurchasesError.unknown))
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            default:
                break
            }
        }
        productPurchaseCallback = nil
    }
}

extension Purchases {
    func finishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
        return true
    }
}
