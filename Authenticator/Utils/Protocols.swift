//
//  Protocols.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 05.01.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

protocol CopyPassToClipBoardDelegate : class {
    func pressCopyButton(otp: String)
}

protocol AddItemDelegate : class {

    func createNewItem (account: String?, issuer: String?, key: String?, timeBased: Bool)
}
