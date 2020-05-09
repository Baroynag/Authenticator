//
//  Protocols.swift
//  TableView
//
//  Created by Anzhela Baroyan on 05.01.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

//protocol RowDetailViewControllerDelegate {
//    func didCooseTheRow(index: Int)
//}

//protocol MarkAsFavoriteDelegate {
//    func markAsFavorite(cell: UITableViewCell)
//}

protocol AuthenticatorViewControllerDelegate : class {
    
  func setEditedText(text: String?, state: States)

}

protocol VC2Delegate : class {
    func titleDidChange (newAuthItem: Authenticator)
}
