//
//  AuthenticatorItem+CoreDataProperties.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 21.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//
//

import Foundation
import CoreData


extension AuthenticatorItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthenticatorItem> {
        return NSFetchRequest<AuthenticatorItem>(entityName: "AuthenticatorItem")
    }

    @NSManaged public var account: String?
    @NSManaged public var issuer: String?
    @NSManaged public var key: String?
    @NSManaged public var priority: Int64
    @NSManaged public var timeBased: Bool
    @NSManaged public var id: UUID?

}
