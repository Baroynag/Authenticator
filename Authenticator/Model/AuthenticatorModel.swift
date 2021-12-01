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

    public func addOneItem(account: String?, issuer: String?, key: String?, priority: Int) throws {

        guard let account = account else {throw CreateTokenError.emptyAccount}
        guard let key = key else {throw CreateTokenError.emptySecret}
        let issuer =  issuer ?? ""

        try createPersistentToken(account: account,
                                  issuer: issuer,
                                  key: key,
                                  priority: priority)
    }

    public func addOneItem(account: String?, issuer: String?, key: String?) throws {

        guard let account = account else {throw CreateTokenError.emptyAccount}
        guard let key = key else {throw CreateTokenError.emptySecret}
        let issuer =  issuer ?? ""

        let priority = getNextPriorityNumber()

        try createPersistentToken(account: account,
                              issuer: issuer,
                              key: key,
                              priority: priority)
    }

    private func createPersistentToken (account: String, issuer: String, key: String, priority: Int) throws {

        if isRecordExist(account: account, issuer: issuer, secret: key) {
            return
        }

        if let token = TokenGenerator.shared.createTimeBasedPersistentToken(name: account,
                                                                            issuer: issuer,
                                                                            secretString: key,
                                                                            priority: priority) {
            sotpPersistentTokenItems.append(token)
        } else {
            throw CreateTokenError.tokenCreateError
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
                dictionary[UUID().uuidString] =
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

    private func getRecords(retryAmount: Int) {
        var retry = retryAmount
        tryGetAllDataFromKeychain {[weak self] in
            if retry > 0 {
                retry -= 1
                self?.getRecords(retryAmount: retry)

            }
        }
    }

    public func isAnyRecords() -> Bool {
        getRecords(retryAmount: 3)
        return isAnyData()
    }

    public func tryGetAllDataFromKeychain(errorHandler: () -> Void) {
        do {
            try getAllSOTPTokens()
        } catch {
            errorHandler()
        }

    }

    public func refreshModel() {
        sotpPersistentTokenItems = []
        try? getAllSOTPTokens()
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

    public func getAllSOTPTokens() throws {
        let tokens = try Array(SOTPKeychain.shared.allPersistentTokens())
        sotpPersistentTokenItems = tokens.sorted(by: { $0.priority ?? 0 < $1.priority ?? 0 })
    }

    public func importFromGoogleAuthenticator (migrationData: MigrationPayload?) throws {

        if let otpParameters = migrationData?.otpParameters {
            for otpParameter in otpParameters {
                let key = MF_Base32Codec.base32String(from: otpParameter.secret)
                try AuthenticatorModel.shared.addOneItem(account: otpParameter.name,
                                                         issuer: otpParameter.issuer,
                                                         key: key)
            }
        } else {
            throw QRCodeScanerError.otpParametersParsingFailled
        }
    }

    public func importFromGoogleAuthenticatorURL(urlString: String) throws {
        if let migrationPayload = QRImageScaner.getMigrationDataFromURLString(urlString: urlString) {
            try AuthenticatorModel.shared.importFromGoogleAuthenticator(migrationData: migrationPayload)
        } else {
            throw QRCodeScanerError.wrongProtbufFormat
        }
    }

    public func createItemFromURLString(urlString: String) throws {
        guard let url = URLComponents(string: urlString) else {
            return
        }

        let account   = url.path.replacingOccurrences(of: "/", with: "")
        let issuer    = QRImageScaner.getQueryStringParameter(url: url, param: "issuer")
        let key       = QRImageScaner.getQueryStringParameter(url: url, param: "secret")

        try addOneItem(account: account,
                       issuer: issuer,
                       key: key)
   }

    public func loadFromScannedGoogleAuthenticatorImage(image: UIImage) throws {
        if let migrationPayload = QRImageScaner.getGoogleAuthenticatorInfo(image: image) {
            try AuthenticatorModel.shared.importFromGoogleAuthenticator(migrationData: migrationPayload)
        } else {
            throw QRCodeScanerError.failledScanningQR
        }
    }
}
