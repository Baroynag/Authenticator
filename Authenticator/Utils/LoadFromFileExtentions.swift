//
//  LoadFromFileExtentions.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 07.09.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import MobileCoreServices

extension UIAlertController {
    class public func promptForPassword(completion: @escaping (String?) -> Void) -> UIAlertController {
        let title = NSLocalizedString("Enter password", comment: "")
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("Password", comment: "")
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default)
        
        let submitTitle = NSLocalizedString("Ok", comment: "")
        let submitAction = UIAlertAction(title: submitTitle, style: .default) { [unowned alert] _ in
            if let answer = alert.textFields?[0] {
                if let pass = answer.text {
                    if pass == ""{
                        cancelAction.isEnabled = false
                    } else {
                        completion(pass)
                    }
                }
            }
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    class public func alertWithOk(title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default)
        alert.addAction(submitAction)
        return alert
    }
    
}

extension UIViewController {
    public func chooseDocument(vcWithDocumentPicker: UIViewController) {
        if let viewController = vcWithDocumentPicker as? UIDocumentPickerDelegate {
            let documentPicker = UIDocumentPickerViewController(
                documentTypes: ["public.item"],
                in: UIDocumentPickerMode.import)
            
            documentPicker.delegate = viewController
            
            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            vcWithDocumentPicker.present(documentPicker, animated: true)
        }
    }
}
