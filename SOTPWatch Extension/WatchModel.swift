//
//  WatchModel.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.10.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation

import CoreData

class AuthenticatorForWatchItem: NSManagedObject {

    @NSManaged public var account: String?
    @NSManaged public var issuer: String?
    @NSManaged public var key: String?
    @NSManaged public var priority: Int64
    @NSManaged public var id: UUID?

}
