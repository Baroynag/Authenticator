//
//  SOTPTokenAtributes.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.01.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation

struct SOTPTokenAtributes: Codable {
    
    var issuer: String
    var name: String
    var priority: Int = 0
    
    init(sotpToken: SOTPPersistentToken) {
        self.priority = sotpToken.priority ?? 0
        self.issuer = sotpToken.token?.issuer ?? ""
        self.name = sotpToken.token?.name ?? ""
    }
}
