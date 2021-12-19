//
//  CreateTokenError.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 22.10.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation

enum CreateTokenError: Error {
    case emptyAccount
    case emptySecret
    case tokenCreateError
}

extension CreateTokenError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyAccount:
            return NSLocalizedString("Account can't be empty", comment: "")
        case .emptySecret:
            return NSLocalizedString("Secret the password!", comment: "")
        case .tokenCreateError:
            return NSLocalizedString("Unable to create account", comment: "")
       }
    }
}
