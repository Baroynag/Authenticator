///
//  Token+Codable.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.01.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation
import OneTimePassword

extension Token: Encodable {
    enum TokenCodingKeys: CodingKey {
        case issuer
        case name
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TokenCodingKeys.self)
        try container.encode(issuer, forKey: .issuer)
        try container.encode(name, forKey: .name)
    }
}
