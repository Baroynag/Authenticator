//
//  AuthenticationList+CoreDataProperties.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//
//

import Foundation
import CoreData


extension AuthenticationList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthenticationList> {
        return NSFetchRequest<AuthenticationList>(entityName: "AuthenticationList")
    }

    @NSManaged public var account: String?
    @NSManaged public var timeBased: Bool
    @NSManaged public var key: String?

}
