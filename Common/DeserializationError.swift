//
//  DeserializationError.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.01.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation

enum DeserializationError: Error {
    case missingData
    case missingSecret
    case missingPersistentRef
    case unreadableData
}
