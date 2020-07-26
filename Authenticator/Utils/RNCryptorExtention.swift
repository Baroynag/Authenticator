//
//  RNCryptorExtention.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 26.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import RNCryptor

extension RNCryptor{
    
    static func encrypt(plainText : String, password: String) -> String {
        let data: Data = plainText.data(using: .utf8)!
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)
        let encryptedString : String = encryptedData.base64EncodedString()
        return encryptedString
    }
       
    static func decrypt(encryptedText : String, password: String) -> String {
        do  {
            let data: Data = Data(base64Encoded: encryptedText)!
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            return decryptedString ?? ""
        }
        catch {
            return "Decryption error"
        }
       }
}
