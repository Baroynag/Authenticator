//
//  SettingsViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 28.06.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import MobileCoreServices
import QuickLookThumbnailing

class SettingsViewController: UIViewController {

//    MARK: - Properties
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
            
            guard let jsonData = data.data(using: .utf8) else {
                print("Error to upload file")
                return}

            guard let jsonResponse = (try? JSONSerialization.jsonObject(with: jsonData)) as? [[String:Any]] else {
                print("Json serialization error")
                return}
            AuthenticatorModel.shared.saveDataBromBackupToCoreData(backupData: jsonResponse)
            
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
    func saveBackupFile(){

        let objects = AuthenticatorModel.shared.saveDataToFile()
        let jsonData = AuthenticatorModel.shared.convertToJSONArray(objectsArray: objects)
        let temporaryFolder = FileManager.default.temporaryDirectory
        let tempFileName = "sotpbackup.sotp"
        let temporaryFilePath = temporaryFolder.appendingPathComponent(tempFileName)
        
        if let jsonString = try? JSONSerialization.data(withJSONObject: jsonData) {
     
            do{
                try jsonString.write(to: temporaryFilePath)
                
                let activityViewController = UIActivityViewController(activityItems: [temporaryFilePath], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
    }
            
            
//    MARK: - Handlers
    @objc func handleSaveToBackup(){
        saveBackupFile()
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
