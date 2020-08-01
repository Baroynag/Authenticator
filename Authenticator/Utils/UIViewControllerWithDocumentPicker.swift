//
//  UIViewControllerWithDocumentPicker.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import MobileCoreServices


class UIViewControllerWithDocumentPicker: UIViewController {
    
    weak var refreshTableDelegate: RefreshTableDelegate?
    
    func promptForPassword(completion: @escaping (String?) -> ()){
        let alert = UIAlertController(title: NSLocalizedString("Enter password", comment: "") , message: nil, preferredStyle: .alert)

        alert.addTextField { (textField: UITextField) in
            textField.isSecureTextEntry = true

            textField.placeholder = NSLocalizedString("Password", comment: "")
            textField.addTarget(self,
                action: #selector(self.textFieldDidChange),
                for: .editingChanged
            )
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
        submitAction.isEnabled = false

        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    @objc private func textFieldDidChange(sender: AnyObject) {
        if let tf = sender as? UITextField{
            var responderList: UIResponder = tf

            while !(responderList is UIAlertController) {
                if let resp = responderList.next{
                    responderList = resp
                }
            }
            if let alert = responderList as? UIAlertController{
                (alert.actions[0] as UIAlertAction).isEnabled = (tf.text != "")
            }
        }
    }

    public func chooseDocument(completion: @escaping(Bool) -> ()){
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePlainText), String(kUTTypeData)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self

        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true) {
            completion(true)
        }

    }
}

extension UIViewControllerWithDocumentPicker: UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        
        guard let selectedFileURL = urls.first else {return}
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let filePath = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
         
            dismiss(animated: true) { [weak self ] in
                self?.promptForPassword { (pass) in
                    if let pass = pass{
                        Backup.getFileContent(fileURL: filePath, password: pass)
                        self?.refreshTableDelegate?.refresh()
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

