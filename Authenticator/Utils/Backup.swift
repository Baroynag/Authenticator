//
//  Backup.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import RNCryptor

class Backup {

    static private let temporaryFolder = FileManager.default.temporaryDirectory
    static private let temporaryFilePathComponent = "sotpbackup.sotp"

    class private func getEncriptedData(password: String) -> String? {
        let jsonData = AuthenticatorModel.shared.getBackUpData()
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let encryptedText = RNCryptor.encrypt(plainText: jsonString, password: password)
            return encryptedText
        }
        return nil
    }
    class public func getFileContent (fileURL: URL, password: String?) throws {

        guard let password = password else {
            throw LoadBackupError.emptyPassword
        }

        if password == "" {
            throw LoadBackupError.emptyPassword
        }

        do {
            let data = try String(contentsOf: fileURL)
            let decriptedText = RNCryptor.decrypt(encryptedText: data, password: password)
            guard let jsonData = decriptedText.data(using: .utf8) else {
                throw LoadBackupError.loadError
            }
            do {
                let tokens = try JSONDecoder().decode([SOTPToken].self, from: jsonData)
                saveData(tokens: tokens)
                AuthenticatorModel.shared.refreshModel()
            }
        }
    }

    class private func saveData(tokens: [SOTPToken]) {
        for sotpToken in tokens {
            try? AuthenticatorModel.shared.addOneItem(account: sotpToken.name,
                                                 issuer: sotpToken.issuer,
                                                 key: sotpToken.secret,
                                                 priority: sotpToken.priority)
        }
    }

    static public func getTemporaryFilePathForBackup() -> URL {
        return temporaryFolder.appendingPathComponent(temporaryFilePathComponent)
    }

    static public func prepareFileForBackup(password: String) throws  -> String {
        guard let backupFile = getEncriptedData(password: password) else {
            throw SaveBackupError.unableToSaveFile
        }
        return backupFile
    }
}

enum SaveBackupError: Error {
    case unableToSaveFile
}

enum LoadBackupError: Error {
    case emptyPassword
    case loadError
}
