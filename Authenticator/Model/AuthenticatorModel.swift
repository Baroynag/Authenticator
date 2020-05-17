//
//  AuthenticatorModel.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Authenticator{
    
    var issuer: String?
    var key: String?
    var account: String = ""
    var timeBased: Bool = true
    
}

class AuthenticatorModel {

    static let shared = AuthenticatorModel()
    
    var authList: [NSManagedObject] = []
    
    func loadData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchREquest = NSFetchRequest<NSManagedObject>(entityName: "AuthenticationList")
        do{
            authList = try managedContext.fetch(fetchREquest)
        } catch let error as NSError{
            print ("Failed to fetch items ", error)
        }
    }
    
    func addOneItem(newAuthItem: Authenticator){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entry = NSEntityDescription.entity(forEntityName: "AuthenticationList", in: managedContext)!
        
        let item = NSManagedObject(entity: entry, insertInto: managedContext)
        
        item.setValue(newAuthItem.issuer,    forKey: "issuer")
        item.setValue(newAuthItem.key,       forKey: "key")
        item.setValue(newAuthItem.account,   forKey: "account")
        item.setValue(newAuthItem.timeBased, forKey: "timeBased")
        do{
            try managedContext.save()
            authList.append(item)
        } catch let error as NSError{
            print ("failure ", error)
        }
        

    }
    
    func deleteData(index: Int){
        
        guard let account = authList[index].value(forKey: "account") as? String else { return}
        authList.remove(at: index)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthenticationList")
        request.predicate = NSPredicate(format:"account = %@", account as CVarArg)
        let result = try? context.fetch(request)
        let resultData = result as! [NSManagedObject]
                
        for object in resultData {
                context.delete(object)
        }
        
        do {
            try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print("general error")
            }
    }
    
}
