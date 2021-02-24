//
//  SOTPKeychain.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.01.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//
import Foundation
import OneTimePassword

final class SOTPKeychain {
    static let shared = SOTPKeychain()
    private let kSOTPService = "am.baroynag.SOTP.token"
    
    private init() {
    }
    
    func add(_ token: SOTPPersistentToken) throws -> Data {
        let attributes = try keychainAttributes(sotpToken: token)
        let persistentRef = try addKeychainItem(withAttributes: attributes)
        return persistentRef
    }

    func keychainAttributes(sotpToken: SOTPPersistentToken) throws -> [String: AnyObject] {

        let tokenAtributes = SOTPTokenAtributes(sotpToken: sotpToken)
        
        guard
            let secretText = sotpToken.plainSecret,
            let atributes = try? JSONEncoder().encode(tokenAtributes) else {
            return [:]
        }
        
        let secretData = Data(secretText.utf8)
        return [
            kSecAttrGeneric as String: atributes as NSData,
            kSecValueData as String: secretData as NSData,
            kSecAttrService as String: kSOTPService as NSString
        ]
    }

    private func addKeychainItem(withAttributes attributes: [String: AnyObject]) throws -> Data {
        var mutableAttributes = attributes
        mutableAttributes[kSecClass as String] = kSecClassGenericPassword
        mutableAttributes[kSecReturnPersistentRef as String] = kCFBooleanTrue

        if mutableAttributes[kSecAttrAccount as String] == nil {
            mutableAttributes[kSecAttrAccount as String] = UUID().uuidString as NSString
        }

        var result: AnyObject?
        let resultCode: OSStatus = withUnsafeMutablePointer(to: &result) {
            SecItemAdd(mutableAttributes as CFDictionary, $0)
        }

        guard resultCode == errSecSuccess else {
            throw Keychain.Error.systemError(resultCode)
        }
        guard let persistentRef = result as? Data else {
            throw Keychain.Error.incorrectReturnType
        }
        return persistentRef
    }

    private func allKeychainItems() throws -> [NSDictionary] {
        let queryDict: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnPersistentRef as String: kCFBooleanTrue,
            kSecReturnAttributes as String: kCFBooleanTrue,
            kSecReturnData as String: kCFBooleanTrue
        ]

        var result: AnyObject?
        let resultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryDict as CFDictionary, $0)
        }

        if resultCode == errSecItemNotFound {
            return []
        }
        guard resultCode == errSecSuccess else {
            throw Keychain.Error.systemError(resultCode)
        }
        guard let keychainItems = result as? [NSDictionary] else {
            throw Keychain.Error.incorrectReturnType
        }

        return keychainItems
    }

    public func allPersistentTokens() throws -> Set<SOTPPersistentToken> {
        let tokens = try allKeychainItems().compactMap({ try? SOTPPersistentToken(keychainDictionary: $0) })
        return Set(tokens)
    }

    public func deleteKeychainItem(forPersistentRef persistentRef: Data) throws {
        let queryDict: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecValuePersistentRef as String: persistentRef as NSData]

        let resultCode = SecItemDelete(queryDict as CFDictionary)

        guard resultCode == errSecSuccess else {
            throw Keychain.Error.systemError(resultCode)
        }
    }

    public func update(_ token: SOTPPersistentToken) throws {
        guard let identifier = token.identifier else {return}

        let attributes = try keychainAttributes(sotpToken: token)
        try self.updateKeychainItem(identifier: identifier, withAttributes: attributes)
    }

    private func updateKeychainItem(identifier: Data, withAttributes attributesToUpdate: [String: AnyObject]) throws {
        let queryDict: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecValuePersistentRef as String: identifier as NSData
        ]

        let resultCode = SecItemUpdate(queryDict as CFDictionary, attributesToUpdate as CFDictionary)

        guard resultCode == errSecSuccess else {
            throw Keychain.Error.systemError(resultCode)
        }
    }
}
