//
//  SOTPToken.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.01.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation

struct SOTPToken: Decodable {
    let issuer: String
    let name: String
    let priority: Int
    let secret: String
}
