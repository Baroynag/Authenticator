//
//  Protocols.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 05.01.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

protocol AuthenticatorViewControllerDelegate : class {
  func setEditedText(text: String?, state: States)
}

protocol AddItemDelegate : class {

    func createNewItem (newAuthItem: Authenticator)
}
