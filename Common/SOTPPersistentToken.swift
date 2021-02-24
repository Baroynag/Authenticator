//
//  SOTPPersistentToken.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.01.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Base32
import Foundation
import OneTimePassword

struct SOTPPersistentToken: Hashable, Encodable {
    
    var identifier: Data?
    var priority: Int?
    var token: Token?
    var plainSecret: String?
    
    init(priority: Int, token: Token, plainSecret: String) {
        self.priority = priority
        self.token = token
        self.plainSecret = plainSecret
        
        saveToKeychain(token: &self)
    }
    
    init(
        tokenAtributes: SOTPTokenAtributes,
        generator: Generator,
        identifier: Data,
        plainSecret: String
    ) {
        self.token = Token(
            name: tokenAtributes.name,
            issuer: tokenAtributes.issuer,
            generator: generator)
        self.priority = tokenAtributes.priority
        self.identifier = identifier
        self.plainSecret = plainSecret
    }
    
    init(keychainDictionary: NSDictionary) throws {
        guard let jsonData = keychainDictionary[kSecAttrGeneric as String] as? Data else {
            throw DeserializationError.missingData
        }
        guard let secret = keychainDictionary[kSecValueData as String] as? Data else {
            throw DeserializationError.missingSecret
        }
        guard let keychainItemRef = keychainDictionary[kSecValuePersistentRef as String] as? Data else {
            throw DeserializationError.missingPersistentRef
        }
        let tokenAtributes = try JSONDecoder().decode(SOTPTokenAtributes.self, from: jsonData)
        
        let secretString = String(decoding: secret, as: UTF8.self)
        
        guard let secretData = MF_Base32Codec.data(fromBase32String: secretString),
              !secretData.isEmpty else {
            throw DeserializationError.missingSecret}
        
        guard let generator = Generator(factor: .timer(period: 30), secret: secretData, algorithm: .sha1, digits: 6) else {
            throw DeserializationError.missingSecret}
        
        self.init(tokenAtributes: tokenAtributes, generator: generator, identifier: keychainItemRef, plainSecret: secretString)
    }
    
    func saveToKeychain(token: inout SOTPPersistentToken) {
        do {
            token.identifier = try SOTPKeychain.shared.add(token)
        } catch {
            print("Keychain error: \(error)")
        }
    }
}
