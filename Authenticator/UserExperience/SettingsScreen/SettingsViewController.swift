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
        button.setTitle("Выгрузить данные в архив", for: .normal)
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
        button.setTitle("Загрузить данные из архива", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handleLoadFromBackup), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cancelButton"), for: .normal)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        return button
    }()
    
//    MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
//    MARK: Functions
    private func setupView(){
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
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 48),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 80),
            cancelButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func getFileContent (fileURL: URL){
        print(#function)
        do{
            let data = try String(contentsOf: fileURL)
            let decriptedText = decrypt(encryptedText: data, password: "password")
           
            guard let jsonData = decriptedText.data(using: .utf8) else {
                print("Error to upload file")
                return}

            guard let jsonResponse = (try? JSONSerialization.jsonObject(with: jsonData)) as? [[String:Any]] else {
                print("Json serialization error")
                return}
            print("-----save")
            self.saveDataBromBackupToCoreData(backupData: jsonResponse)
            print("-----save")
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
    func encrypt(plainText : String, password: String) -> String {
            let data: Data = plainText.data(using: .utf8)!
            let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)
            let encryptedString : String = encryptedData.base64EncodedString() // getting base64encoded string of encrypted data.
            return encryptedString
    }
    
    func decrypt(encryptedText : String, password: String) -> String {
            do  {
                let data: Data = Data(base64Encoded: encryptedText)! // Just get data from encrypted base64Encoded string.
                let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
                let decryptedString = String(data: decryptedData, encoding: .utf8) // Getting original string, using same .utf8 encoding option,which we used for encryption.
                return decryptedString ?? ""
            }
            catch {
                return "FAILED"
            }
    }
    
    func saveBackupFile(password: String){
        
        let objectsFromDatabase = AuthenticatorModel.shared.saveDataToFile()
        let jsonArray = AuthenticatorModel.shared.convertToJSONArray(objectsArray: objectsFromDatabase)
        let temporaryFolder = FileManager.default.temporaryDirectory
        let tempFileName = "sotpbackup.sotp"
        let temporaryFilePath = temporaryFolder.appendingPathComponent(tempFileName)
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray) {
            if let jsonString = String(data: jsonData, encoding: .utf8){
                let encryptedText = encrypt(plainText: jsonString, password: "password")
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
    
        var newItem = Authenticator()
        
        for item in backupData{
            newItem.account = item["account"] as? String ?? ""
            newItem.key = item["key"] as? String ?? ""
            newItem.issuer = item["issuer"] as? String ?? ""
            newItem.timeBased = item["timeBased"] as? Bool ?? false
            delegate?.createNewItem(newAuthItem: newItem)
            
            print(newItem)
        }
    }
    
    func getPassword(completion: @escaping (String?) -> () ){
      
        let passwordViewController = PasswordViewController()
        passwordViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(passwordViewController, animated: true)
        passwordViewController.callBack = { password in
           completion(password)
        }
    }
            
//    MARK: - Handlers
    @objc func handleSaveToBackup(){
        print(#function)
        getPassword { [weak self ](pass) in
            if let pass = pass{
                self?.saveBackupFile(password: pass)
            }
        }

    }
    
    @objc func handleLoadFromBackup(){
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePlainText), String(kUTTypeData)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
    }

    @objc private func handleCancelButton(){
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        
        guard let selectedFileURL = urls.first else {return}
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let filePath = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
            getFileContent(fileURL: filePath)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}


