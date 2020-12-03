//
//  LoadFromFileExtentions.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 07.09.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import MobileCoreServices

extension UIAlertController{
    
    class public func promptForPassword(completion: @escaping (String?) -> ()) -> UIAlertController{
         let alert = UIAlertController(title: NSLocalizedString("Enter password", comment: "") , message: nil, preferredStyle: .alert)

         alert.addTextField { (textField: UITextField) in
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("Password", comment: "")
         }

         let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "") , style: .default)

         let submitAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "") , style: .default) { [unowned alert] _ in
             if let answer = alert.textFields?[0]{
                 if let pass = answer.text{
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

    class public func alertWithOk(title: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "") , style: .default)
        alert.addAction(submitAction)
        return alert
    }
    
}



extension UIViewController{
   
    public func chooseDocument(vcWithDocumentPicker: UIViewController){
        if let vc = vcWithDocumentPicker as? UIDocumentPickerDelegate {
            let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes:
                ["public.item"],
                in: UIDocumentPickerMode.import)
            
            documentPicker.delegate = vc

            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            vcWithDocumentPicker.present(documentPicker, animated: true)
        }
    }
}

extension SettingsTableViewController: UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        
        var title = NSLocalizedString("Wrong password", comment: "")
        
        if let fileUrl = urls.first{
            dismiss(animated: true) { [weak self ] in
                let promtForPassword = UIAlertController.promptForPassword { (pass) in
                    if let pass = pass{
                        if Backup.getFileContent(fileURL: fileUrl, password: pass){
                            self?.refreshTableDelegate?.refresh()
                            
                            title = NSLocalizedString("Data loaded", comment: "")
                        }
                    }
                    let alert = UIAlertController.alertWithOk(title: title)
                    self?.present(alert, animated: true)
                   
                }
                self?.present(promtForPassword, animated: true)
                
            }
        }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}



extension GreetingViewController: UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        
        
        let title = NSLocalizedString("Wrong password", comment: "")
        
        if let fileURL = urls.first{
            
            dismiss(animated: true) { [weak self ] in
             
                let promtForPassword = UIAlertController.promptForPassword { (pass) in
                    
                    if let pass = pass{
                        if Backup.getFileContent(fileURL: fileURL, password: pass){
                            self?.refreshTableDelegate?.refresh()
                            self?.delegate?.didTapCreate()
                        } else{
                            let alert = UIAlertController.alertWithOk(title: title)
                            self?.present(alert, animated: true)
                        }
                    }
                }
                self?.present(promtForPassword, animated: true)
                
            }
        }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

