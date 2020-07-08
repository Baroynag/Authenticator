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
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
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
    
    func saveBackupFile(){

        let objects = AuthenticatorModel.shared.saveDataToFile()
        let jsonData = AuthenticatorModel.shared.convertToJSONArray(objectsArray: objects)
        
        if let jsonString = try? JSONSerialization.data(withJSONObject: jsonData) {

            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let file2ShareURL = documentsDirectoryURL.appendingPathComponent("sotpbackup.txt")
           
            do{
                try jsonString.write(to: file2ShareURL)
                let activityViewController = UIActivityViewController(activityItems: [file2ShareURL], applicationActivities: nil)
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
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePlainText)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
        
    }

}


extension SettingsViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        do{
            let data = try String(contentsOf: sandboxFileURL)
            
            guard let jsonData = data.data(using: .utf8) else {return}
            print("jsonData")
            print(jsonData)
            guard let jsonResponse = (try? JSONSerialization.jsonObject(with: jsonData)) as? [[String:Any]] else {return}
            
            print("jsonResponse")
            print(jsonResponse)
            
        }
        catch{
            print(error.localizedDescription)
        }
 
        print("Task completed")
        
        /*if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("Already exists! Do nothing")
        }
        else {
            
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                print("Copied file!")
            }
            catch {
                print("Error: \(error)")
            }
        }*/
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}
