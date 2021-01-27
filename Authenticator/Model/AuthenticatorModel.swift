//
//  AuthenticatorModel.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation
import CoreData
import OneTimePassword
import Base32

class AuthenticatorModel {

    static let shared = AuthenticatorModel()

    public var sotpPersistentTokenItems: [SOTPPersistentToken] = []

    private func isRecordExist(account: String, issuer: String, secret: String) -> Bool {
        for sotpPersistentToken in sotpPersistentTokenItems {
            if let tokenSecret = sotpPersistentToken.token?.generator.secret {
                if account == sotpPersistentToken.token?.name &&
                    issuer == sotpPersistentToken.token?.issuer &&
                    secret ==  String(data: tokenSecret, encoding: .utf8) {
                    return true
                }
            }
        }

        return false
    }

    private func isRecordExist(token: SOTPToken) -> Bool {

        for sotpPersistentToken in sotpPersistentTokenItems {
            if let tokenSecret = sotpPersistentToken.token?.generator.secret {
                if token.name == sotpPersistentToken.token?.name &&
                    token.issuer == sotpPersistentToken.token?.issuer &&
                    token.secret ==  String(data: tokenSecret, encoding: .utf8) {
                    return true
                }
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
        print("createPersistentToken \(key)")
        if let token = createTimeBasedToken(name: account, issuer: issuer, secretString: key, priority: priority) {
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
//        print(sotpTokenItems)
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

    private func createTimeBasedToken(name: String, issuer: String, secretString: String, priority: Int) -> SOTPPersistentToken? {

        print("createTimeBasedToken \(secretString)")
        guard let generator = createGenerator(secretString: secretString, period: 30, digits: 6) else { return nil}
        print("createTimeBasedToken \(generator.secret)")
        print("createTimeBasedToken \(String(data: generator.secret, encoding: .utf8))")
        let token = Token(name: name, issuer: issuer, generator: generator)
        let sotpToken = SOTPPersistentToken(priority: priority, token: token)
        return sotpToken
    }

    private func createGenerator (secretString: String, period: Double, digits: Int) -> Generator? {

        guard let secretData = MF_Base32Codec.data(fromBase32String: secretString),
            !secretData.isEmpty else {
            print("Invalid generator parameters. Can't convert to data")
            return nil
        }

        guard let generator = Generator(
            factor: .timer(period: period),
            secret: secretData,
            algorithm: .sha1,
            digits: digits) else {
                print("Invalid generator parameters")
                return nil
        }

        return generator
    }

    private func isValidSecretKey(secretKey: String) -> Bool {

        if secretKey.isEmpty {return false}

        guard let key = MF_Base32Codec.data(fromBase32String: secretKey),
            !key.isEmpty else {
            return false}

        return true
    }

}
