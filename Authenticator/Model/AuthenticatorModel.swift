//
//  AuthenticatorModel.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation
import OneTimePassword
import Base32

class AuthenticatorModel {

    static let shared = AuthenticatorModel()

    public var sotpPersistentTokenItems: [SOTPPersistentToken] = []

    private init() {
    }

    private func isRecordExist(account: String, issuer: String, secret: String) -> Bool {
        for sotpPersistentToken in sotpPersistentTokenItems {
            if account == sotpPersistentToken.token?.name &&
                issuer == sotpPersistentToken.token?.issuer &&
                secret == sotpPersistentToken.plainSecret {
                return true
            }
        }

        return false
    }

    public func addOneItem(account: String?, issuer: String?, key: String?, priority: Int) {

        let account = account ?? ""
        let issuer =  issuer ?? ""
        let key =  key ?? ""

        createPersistentToken(account: account,
                              issuer: issuer,
                              key: key,
                              priority: priority)
    }

    public func addOneItem(account: String?, issuer: String?, key: String?) {

        let account = account ?? ""
        let issuer =  issuer ?? ""
        let key =  key ?? ""

        let priority = getNextPriorityNumber()

        createPersistentToken(account: account,
                              issuer: issuer,
                              key: key,
                              priority: priority)
    }

    private func createPersistentToken (account: String, issuer: String, key: String, priority: Int) {

        if isRecordExist(account: account, issuer: issuer, secret: key) {
            return
        }

        if let token = TokenGenerator.shared.createTimeBasedPersistentToken(name: account, issuer: issuer, secretString: key, priority: priority) {
            sotpPersistentTokenItems.append(token)
        }
    }

    public func deleteData(index: Int) {

        let itemToRemove = sotpPersistentTokenItems[index]
        if let identifier = itemToRemove.identifier {
            try? SOTPKeychain.shared.deleteKeychainItem(forPersistentRef: identifier)
            sotpPersistentTokenItems.remove(at: index)
        }
    }

    func loadDataForWatch() -> [String: [String: String]] {
        var dictionary: [String: [String: String]] = [:]
        for item in sotpPersistentTokenItems {

            if let issuer = item.token?.issuer,
               let name = item.token?.name {
               dictionary[issuer] =
                    ["issuer": issuer,
                    "key": item.plainSecret ?? "",
                    "priority": String(item.priority ?? 0),
                    "name": name]
                    }
                }
        return dictionary
    }

    public func getBackUpData() -> Data {

        var result = Data()

        do {
            let jsonData = try JSONEncoder().encode(sotpPersistentTokenItems)
            result.append(jsonData)
        } catch {
            print(error.localizedDescription)
        }

        return result

    }

    public func isAnyData() -> Bool {
        let count = AuthenticatorModel.shared.sotpPersistentTokenItems.count
        return count > 0
    }

    public func isAnyRecords() -> Bool {
        getAllSOTPTokens()
        return isAnyData()
    }

    public func refreshModel() {
        sotpPersistentTokenItems = []
        getAllSOTPTokens()
    }

    public func swapPriority(fromIndex: Int, toIndex: Int) {

        let count = sotpPersistentTokenItems.count
        if count < 2 {return}

        let item = sotpPersistentTokenItems[fromIndex]
        sotpPersistentTokenItems.remove(at: fromIndex)
        sotpPersistentTokenItems.insert(item, at: toIndex)

        for index in 0...count - 1 {
            sotpPersistentTokenItems[index].priority = Int(index + 1)
            let token = sotpPersistentTokenItems[index]
                try? SOTPKeychain.shared.update(token)
        }
    }

    private func getNextPriorityNumber() -> Int {
        return sotpPersistentTokenItems.count + 1
    }

    public func getAllSOTPTokens() {

        let tokens = try? Array(SOTPKeychain.shared.allPersistentTokens())
        sotpPersistentTokenItems = tokens?.sorted(by: { $0.priority ?? 0 < $1.priority ?? 0 }) ?? []
    }

    public func deleteAllData() {
        try? SOTPKeychain.shared.deleteAllKeychainItem()
    }

}
