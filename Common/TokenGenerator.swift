//
//  TokenGenerator.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 08.02.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import OneTimePassword
import Base32

class TokenGenerator {

    static let shared = TokenGenerator()

    public func createTimeBasedPersistentToken(name: String, issuer: String, secretString: String, priority: Int) -> SOTPPersistentToken? {

        guard let generator = createGenerator(secretString: secretString, period: 30, digits: 6) else { return nil}

        let token = Token(name: name, issuer: issuer, generator: generator)
        let sotpPersistentToken = SOTPPersistentToken(priority: priority, token: token, plainSecret: secretString)
        return sotpPersistentToken
    }

    public func createTimeBasedToken(name: String, issuer: String, secretString: String, priority: Int) -> Token? {

        guard let generator = createGenerator(secretString: secretString, period: 30, digits: 6) else { return nil}
        let token = Token(name: name, issuer: issuer, generator: generator)
        return token
    }

    public func createGenerator (secretString: String, period: Double, digits: Int) -> Generator? {

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
