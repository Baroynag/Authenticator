//
//  Backup.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import RNCryptor


class Backup{
    
    class public func getEncriptedData(password: String) -> String?{
    
        let jsonArray = AuthenticatorModel.shared.convertCoreDataObjectsToJSONArray()
        

        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray) {
            if let jsonString = String(data: jsonData, encoding: .utf8){
                let encryptedText = RNCryptor.encrypt(plainText: jsonString, password: password)
                return encryptedText
            }
        }
        
        return nil
    }
    
    class public func getFileContent (fileURL: URL, password: String){
        //TODO: add error message
        
        if password == "" {
           return
        }
        
        do{
            let data = try String(contentsOf: fileURL)
            let decriptedText = RNCryptor.decrypt(encryptedText: data, password: password)
            guard let jsonData = decriptedText.data(using: .utf8) else {
                print(NSLocalizedString("Error to upload file", comment: ""))
                return}

            guard let jsonResponse = (try? JSONSerialization.jsonObject(with: jsonData)) as? [[String:Any]] else {
                    print(NSLocalizedString("Json serialization error", comment: ""))
                    return}
            AuthenticatorModel.shared.saveDataBromBackupToCoreData(backupData: jsonResponse)
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
}
