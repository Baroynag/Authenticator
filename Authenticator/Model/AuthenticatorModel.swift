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
    private var filteredItems: [AuthenticatorItem]?
    
    func loadData(){
        do{
            self.authenticatorItemsList = try context.fetch(AuthenticatorItem.fetchRequest())
        } catch{
            print(NSLocalizedString("Core data load error", comment: "") ,  error.localizedDescription)
        }
    }
    
    func isRecordExist(account: String, issuer: String, key: String, timeBased: Bool) -> Bool{
      
        let request = AuthenticatorItem.fetchRequest() as NSFetchRequest<AuthenticatorItem>
        
        let predicate = NSPredicate(
            format: "account = %@ AND issuer = %@ AND key = %@ AND timeBased =  %d",
            account, issuer, key, timeBased)
        
        request.predicate = predicate
        
        do{
            self.filteredItems = try context.fetch(request)
            if filteredItems?.count ?? 0  > 0 {
                return true
            }
        } catch{
            print(NSLocalizedString("Core data load error", comment: "") ,  error.localizedDescription)
        }
        
        return false
    }
    
    func addOneItem(account: String?, issuer: String?, key: String?, timeBased: Bool){
        
       if isRecordExist(account: account ?? "", issuer: issuer ?? "", key: key ?? "", timeBased: timeBased){
            return
        }
        
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
            print(NSLocalizedString("Core data save error", comment: "") ,  error.localizedDescription)
        }
    }
    
    
    func deleteData(index: Int){
        
        if let itemToRemove = authenticatorItemsList?[index]{
            self.context.delete(itemToRemove)
            authenticatorItemsList?.remove(at: index)
            
            do {
                try context.save()
            } catch {
               print(NSLocalizedString("Core data delete error", comment: "") ,  error.localizedDescription)
            }
        }
    }
    
    
    
    func loadDataForWatch() -> [String: String] {
        
        loadData()
        
        guard let authenticatorItemsList = authenticatorItemsList else {return [:] }
       
        var dictionary: [String: String] = [:]
        
        for index in 0...authenticatorItemsList.count - 1{
         
            if let authIssuer = authenticatorItemsList[index].value(forKey: "issuer") as? String,
               let authKey = authenticatorItemsList[index].value(forKey: "key")  as? String{
               
                dictionary.updateValue(authKey, forKey: authIssuer)
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
    
    public func isAnyData() -> Bool{
        let count = AuthenticatorModel.shared.authenticatorItemsList?.count ?? 0
        print("count = \(count)")
        return count > 0
    }
    
    public func saveDataBromBackupToCoreData(backupData: [[String:Any]]) {
        
        for item in backupData{
            let account   = item["account"]   as? String ?? ""
            let key       = item["key"]       as? String ?? ""
            let issuer    = item["issuer"]    as? String ?? ""
            let timeBased = item["timeBased"] as? Bool   ?? false
            
            self.addOneItem(account: account, issuer: issuer, key: key, timeBased: timeBased)
        }
    }
    
    public func isAnyRecords() -> Bool{
        loadData()
        return isAnyData()
    }
  
}
