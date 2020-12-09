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

    private func printPriorityLog() {
        guard let authenticatorItemsList = authenticatorItemsList else {return}
        for item in authenticatorItemsList {
            print(" name  = \(String(describing: item.issuer)) priority = \(item.priority)")
        }
    }
    func loadData() {
        do {
            let request = NSFetchRequest<AuthenticatorItem>(entityName: "AuthenticatorItem")
            request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
            self.authenticatorItemsList = try context.fetch(request)
            printPriorityLog()
        } catch {
            print(NSLocalizedString("Core data load error", comment: ""), error.localizedDescription)
        }
    }
    func isRecordExist(account: String, issuer: String, key: String) -> Bool {
        let request = NSFetchRequest<AuthenticatorItem>(entityName: "AuthenticatorItem")
        let predicate = NSPredicate(
            format: "account = %@ AND issuer = %@ AND key = %@",
            account, issuer, key)
        request.predicate = predicate
        do {
            self.filteredItems = try context.fetch(request)
            if filteredItems?.count ?? 0  > 0 {
                return true
            }
        } catch {
            print(NSLocalizedString("Core data load error", comment: ""), error.localizedDescription)
        }
        return false
    }
    func addOneItem(account: String?, issuer: String?, key: String?) {

       if isRecordExist(account: account ?? "", issuer: issuer ?? "", key: key ?? "") {
            return
        }

        let authItem = AuthenticatorItem(context: context)
        authItem.id        = UUID()
        authItem.account   = account
        authItem.issuer    = issuer
        authItem.key       = key
        authItem.priority  = getNextPriorityNumber()
        do {
            try self.context.save()
            authenticatorItemsList?.append(authItem)
        } catch {
            print(NSLocalizedString("Core data save error", comment: ""), error.localizedDescription)
        }
    }
    
    func addOneItem(account: String?, issuer: String?, key: String?, priority: Int64) {

       if isRecordExist(account: account ?? "", issuer: issuer ?? "", key: key ?? "") {
            return
        }

        let authItem = AuthenticatorItem(context: context)
        authItem.id        = UUID()
        authItem.account   = account
        authItem.issuer    = issuer
        authItem.key       = key
        authItem.priority  = priority
        do {
            try self.context.save()
            authenticatorItemsList?.append(authItem)
        } catch {
            print(NSLocalizedString("Core data save error", comment: ""), error.localizedDescription)
        }
    }

    func deleteData(index: Int) {

        if let itemToRemove = authenticatorItemsList?[index] {
            self.context.delete(itemToRemove)
            authenticatorItemsList?.remove(at: index)
            do {
                try context.save()
            } catch {
               print(NSLocalizedString("Core data delete error", comment: ""), error.localizedDescription)
            }
        }
    }
    func loadDataForWatch() -> [String: [String: String]] {
        loadData()
        guard let authenticatorItemsList = authenticatorItemsList else {return [:] }

        var dictionary: [String: [String: String]] = [:]
        for item in authenticatorItemsList {

            if let issuer = item.issuer,
               let key = item.key,
               let uid = item.id?.uuidString {
                dictionary[uid] = ["issuer": issuer,
                    "key": key,
                    "priority": String(item.priority)]
            }
        }
//        for ind in dictionary {
//            print(ind)
//        }
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
                } else {
                    if let itemId = item.id?.uuidString {
                        dictionary[attribute.key] = itemId
                    }
                }
            }
        }
        return jsonArray

    }

    public func isAnyData() -> Bool {
        let count = AuthenticatorModel.shared.authenticatorItemsList?.count ?? 0
        print("count = \(count)")
        return count > 0
    }
    public func saveDataBromBackupToCoreData(backupData: [[String: Any]]) {
        for item in backupData {
            let account   = item["account"]   as? String ?? ""
            let key       = item["key"]       as? String ?? ""
            let issuer    = item["issuer"]    as? String ?? ""
            let priority  = item["priority"]  as? Int64  ?? 0
            self.addOneItem(account: account,
                            issuer: issuer,
                            key: key,
                            priority: priority)
        }
    }

    public func isAnyRecords() -> Bool {
        loadData()
        return isAnyData()
    }

    public func endEditing() {
        if let error = saveContext() {
            print(error.localizedDescription)
        }
    }

    private func saveContext() -> Error? {
        do {
            try self.context.save()
        } catch {
            return error
        }
        return nil
    }

    public func swapPriority(fromIndex: Int, toIndex: Int) {

        if let item = authenticatorItemsList?[fromIndex] {
            authenticatorItemsList?.remove(at: fromIndex)
            authenticatorItemsList?.insert(item, at: toIndex)
            if let count = authenticatorItemsList?.count {
                for index in 0...count - 1 {
                    authenticatorItemsList?[index].priority = Int64(index + 1)
                }
            }
        }

    }

    private func getNextPriorityNumber() -> Int64 {
        var nextPriorityValue: Int64 = 0
        let request = NSFetchRequest<AuthenticatorItem>(entityName: "AuthenticatorItem")
        request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let res = try context.fetch(request)
            nextPriorityValue = res[0].priority + 1
        } catch {
            print("get next priority value error \(error.localizedDescription)")
        }
        return nextPriorityValue
    }
}
