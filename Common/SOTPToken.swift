//
//  SOTPToken.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.01.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation
import OneTimePassword
import Base32

enum CodingKeys: String, CodingKey {
    case issuer
    case name
    case priority
    case secret
}

public struct SOTPPersistentToken: Hashable, Encodable {
    public var identifier: Data?
    public var priority: Int?
    public var token: Token?

    public init(priority: Int, token: Token) {
        self.priority = priority
        self.token = token

        do {
            let tokenIdentifiert = try SOTPKeychain.shared.add(self)
            self.identifier = tokenIdentifiert
            print("Saved to keychain with identifier: \(tokenIdentifiert)")
        } catch {
            print("Keychain error: \(error)")
        }
    }

    public init(tokenAtributes: SOTPTokenAtributes, generator: Generator, identifier: Data) {
        self.token = Token(name: tokenAtributes.name,
                           issuer: tokenAtributes.issuer,
                           generator: generator)
        self.priority = tokenAtributes.priority
        self.identifier = identifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    enum DeserializationError: Error {
        case missingData
        case missingSecret
        case missingPersistentRef
        case unreadableData
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

        guard let generator = Generator(factor: .timer(period: 30), secret: secret, algorithm: .sha1, digits: 6) else {
        throw DeserializationError.missingPersistentRef
        }

        self.init(tokenAtributes: tokenAtributes, generator: generator, identifier: keychainItemRef)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token?.issuer, forKey: .issuer)
        try container.encode(token?.name, forKey: .name)
        try container.encode(priority, forKey: .priority)
        try container.encode(token?.generator.secret, forKey: .secret)
    }

    public func saveToKeychain(token: inout SOTPPersistentToken) {
        do {
            let tokenIdentifiert = try SOTPKeychain.shared.add(token)
            token.identifier = tokenIdentifiert
            print("Saved to keychain with identifier: \(tokenIdentifiert)")
        } catch {
            print("Keychain error: \(error)")
        }
    }
}

public struct SOTPTokenAtributes: Codable {

    var issuer: String = ""
    var name: String = ""
    var priority: Int = 0

    enum CodingKeys: String, CodingKey {
        case issuer
        case name
        case priority
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(issuer, forKey: .issuer)
        try container.encode(name, forKey: .name)
        try container.encode(priority, forKey: .priority)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        issuer = try container.decode(String.self, forKey: .issuer)
        name = try container.decode(String.self, forKey: .name)
        priority = try container.decode(Int.self, forKey: .priority)
    }

    public init(sotpToken: SOTPPersistentToken) {
        self.priority = sotpToken.priority ?? 0
        self.issuer = sotpToken.token?.issuer ?? ""
        self.name = sotpToken.token?.name ?? ""
    }
}

struct SOTPToken: Decodable {
    var issuer: String = ""
    var name: String = ""
    var priority: Int = 0
    var secret: String = ""

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        issuer = try container.decode(String.self, forKey: .issuer)
        name = try container.decode(String.self, forKey: .name)
        priority = try container.decode(Int.self, forKey: .priority)
        secret = try container.decode(String.self, forKey: .secret)
    }

}
