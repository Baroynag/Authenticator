//
//  AuthenticatorModel.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation
import CoreData
import OneTimePassword

class AuthenticatorModel {

    static let shared = AuthenticatorModel()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var authenticatorItemsList: [AuthenticatorItem]?
    
    func loadData(){
        do{
            self.authenticatorItemsList = try context.fetch(AuthenticatorItem.fetchRequest())
        } catch{
            print("Ошибка загрузки данных: \(error.localizedDescription)")
        }
    }
    
    func addOneItem(account: String?, issuer: String?, key: String?, timeBased: Bool){
        let authItem = AuthenticatorItem(context: context)
        authItem.id        = UUID()
        authItem.account   = account
        authItem.issuer    = issuer
        authItem.key       = key
        authItem.timeBased = timeBased
        authenticatorItemsList?.append(authItem)
        do{
            try self.context.save()
        } catch{
            print("Ошибка при сохранении данных \(error.localizedDescription)")
        }
    }
    
    
    func deleteData(index: Int){
        
        if let itemToRemove = authenticatorItemsList?[index]{
            self.context.delete(itemToRemove)
            authenticatorItemsList?.remove(at: index)
            
            do {
                try context.save()
            } catch {
                print("Ошибка при сохранении \(error.localizedDescription)")
            }
        }
    }
    
    
    func loadDataForWatch() -> [String: String] {
        
        loadData()
        
        guard let authenticatorItemsList = authenticatorItemsList else {return [:] }
        var dictionary: [String: String] = [:]
        
        for index in 0...authenticatorItemsList.count - 1{
            
            if let authIssuer = authenticatorItemsList[index].value(forKey: "issuer") as? String,
                let authKey = authenticatorItemsList[index].value(forKey: "key")  as? String
            {
                let token = TokenGenerator.shared.createToken(name: authIssuer, issuer: authIssuer, secretString: authKey)
            
                if let tokenPass = token?.currentPassword{
                    dictionary.updateValue(tokenPass, forKey: authIssuer)
                }
            }
        }
        return dictionary
    }
    
    func convertCoreDataObjectsToJSONArray() -> [[String: Any]] {
        
        var jsonArray: [[String: Any]] = []
        
        guard let authenticatorItemsList = authenticatorItemsList else {return [[:]] }
        
        for item in authenticatorItemsList {
            var dictionary: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                if attribute.key != "id"{
                    if let value = item.value(forKey: attribute.key) {
                        dictionary[attribute.key] = value
                    }
                } else{
                    if let id = item.id?.uuidString {
                        dictionary[attribute.key] = id
                    }
                }
            }
            jsonArray.append(dictionary)
        }
        return jsonArray
        
    }
  
}
