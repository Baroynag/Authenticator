//
//  SettingsViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 28.06.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import MobileCoreServices
import RNCryptor

class SettingsViewController: UIViewController {

//    MARK: - Properties
    weak var delegate: AddItemDelegate?
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.setTitle(NSLocalizedString("Create backup", comment: "") , for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handleSaveToBackup), for: .touchUpInside)
        return button
    }()
    
    let loadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.setTitle(NSLocalizedString("Load from backup", comment: "") , for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handleLoadFromBackup), for: .touchUpInside)
        return button
    }()
    
//    MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
//    MARK: Functions
    private func setupView(){
        
        setupNavigationController()
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        view.addSubview(loadButton)
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 24),
            loadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            loadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            loadButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
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
    
    
    func getFileContent (fileURL: URL, password: String){
        //TODO: вывести сообщение
        if password == "" {
           return
        }
        
        print(#function)
        do{
            let data = try String(contentsOf: fileURL)
            let decriptedText = decrypt(encryptedText: data, password: password)
           
            guard let jsonData = decriptedText.data(using: .utf8) else {
                print("Error to upload file")
                return}

            guard let jsonResponse = (try? JSONSerialization.jsonObject(with: jsonData)) as? [[String:Any]] else {
                print("Json serialization error")
                return}
            self.saveDataBromBackupToCoreData(backupData: jsonResponse)
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
    func encrypt(plainText : String, password: String) -> String {
            let data: Data = plainText.data(using: .utf8)!
            let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)
            let encryptedString : String = encryptedData.base64EncodedString()
            return encryptedString
    }
    
    func decrypt(encryptedText : String, password: String) -> String {
        do  {
            let data: Data = Data(base64Encoded: encryptedText)!
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            return decryptedString ?? ""
        }
        catch {
            return "FAILED"
        }
    }
    
    func saveBackupFile(password: String){
        
        let jsonArray = AuthenticatorModel.shared.convertCoreDataObjectsToJSONArray()
        let temporaryFolder = FileManager.default.temporaryDirectory
        let temporaryFilePath = temporaryFolder.appendingPathComponent("sotpbackup.sotp")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray) {
            if let jsonString = String(data: jsonData, encoding: .utf8){
                let encryptedText = encrypt(plainText: jsonString, password: password)
                do{
                    try encryptedText.write(to: temporaryFilePath, atomically: true, encoding: .utf8)
                    let activityViewController = UIActivityViewController(activityItems: [temporaryFilePath], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
           
    func saveDataBromBackupToCoreData(backupData: [[String:Any]]) {
        
        for item in backupData{
            let account   = item["account"]   as? String ?? ""
            let key       = item["key"]       as? String ?? ""
            let issuer    = item["issuer"]    as? String ?? ""
            let timeBased = item["timeBased"] as? Bool   ?? false
            
            delegate?.createNewItem(account: account, issuer: issuer, key: key, timeBased: timeBased)
        }
    }
    
    func getPassword(completion: @escaping (String?) -> () ){
        let passwordViewController = PasswordViewController()
        passwordViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController: passwordViewController, animated: true, completion: {
                passwordViewController.callBack = completion
        })
    }
    
    private func chooseDocument(completion: @escaping(Bool) -> ()){
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePlainText), String(kUTTypeData)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
               
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true) {
            completion(true)
        }
    
    }
            
//    MARK: - Handlers
    @objc func handleSaveToBackup(){
        print(#function)
        getPassword { [weak self ](pass) in
            if let pass = pass{
                print ("pass = \(pass)")
                self?.saveBackupFile(password: pass)
            }
        }
    }
    
    @objc func handleLoadFromBackup(){
        chooseDocument { (isEnded) in
                print ("isEnded")
        }
    }

    @objc private func handleCancelButton(){
        dismiss(animated: true, completion: nil)
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
    
    
}

extension SettingsViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        print("documentPicker")
        guard let selectedFileURL = urls.first else {return}
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let filePath = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
         
            dismiss(animated: true) { [weak self ] in
                self?.promptForPassword { (pass) in
                    if let pass = pass{
                        self?.getFileContent(fileURL: filePath, password: pass)
                    }
                }
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}


