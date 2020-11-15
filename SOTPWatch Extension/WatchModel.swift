//
//  WatchModel.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.10.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation


import CoreData


class AuthenticatorForWatchItem: NSManagedObject  {
    
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthenticatorForWatchItem> {
//        return NSFetchRequest<AuthenticatorForWatchItem>(entityName: "AuthenticatorForWatchItem")
//    }
    
    @NSManaged public var account: String?
    @NSManaged public var issuer: String?
    @NSManaged public var key: String?
    @NSManaged public var timeBased: Bool
    @NSManaged public var id: UUID?

}
