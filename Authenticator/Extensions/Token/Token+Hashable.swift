//
//  Token+Hashable.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.01.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation
import OneTimePassword

extension Token: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(issuer)
        hasher.combine(name)
    }
}
