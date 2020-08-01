//
//  TokenGenerator.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 14.06.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import OneTimePassword
import Base32

class TokenGenerator {
    
    static let shared = TokenGenerator()
    
    func createToken(name: String, issuer: String, secretString: String) -> Token? {
    
        guard let secretData = MF_Base32Codec.data(fromBase32String: secretString),
            !secretData.isEmpty else { print("Invalid secret")
                return nil}

        guard let generator = Generator(
            factor: .timer(period: 30),
            secret: secretData,
            algorithm: .sha1,
            digits: 6) else {
                print("Invalid generator parameters")
                return nil
        }

        let token = Token(name: name, issuer: issuer, generator: generator)

        return token
    }
    
    func isValidSecretKey(secretKey: String) -> Bool{
        
        if secretKey.isEmpty {return false}
        
        guard let _ = MF_Base32Codec.data(fromBase32String: secretKey) else {
            return false
        }
        
        return true
            
        
    }

}
