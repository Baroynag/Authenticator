//
//  Backup.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import RNCryptor

class Backup {
    class public func getEncriptedData(password: String) -> String? {
        let jsonData = AuthenticatorModel.shared.getBackUpData()
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let encryptedText = RNCryptor.encrypt(plainText: jsonString, password: password)
            return encryptedText
        }
        return nil
    }
    class public func getFileContent (fileURL: URL, password: String) -> Bool {
        //TODO: add error message
        if password == "" {
           return false
        }
        do {
            let data = try String(contentsOf: fileURL)
            let decriptedText = RNCryptor.decrypt(encryptedText: data, password: password)
            print(decriptedText)
            guard let jsonData = decriptedText.data(using: .utf8) else {
                print(NSLocalizedString("Error to upload file", comment: ""))
                return false }
            do {
                let tokens = try JSONDecoder().decode([SOTPToken].self, from: jsonData)
                saveData(tokens: tokens)
                AuthenticatorModel.shared.refreshModel()
            } catch {
                print("json decoding error \(error.localizedDescription)")
                return false
            }

        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }

    class private func saveData(tokens: [SOTPToken]) {
        for sotpToken in tokens {
            AuthenticatorModel.shared.addOneItem(account: sotpToken.name,
                                                 issuer: sotpToken.issuer,
                                                 key: sotpToken.secret,
                                                 priority: sotpToken.priority)
        }
    }
}
