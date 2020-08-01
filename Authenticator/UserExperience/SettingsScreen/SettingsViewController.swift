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

class SettingsViewController: UIViewControllerWithDocumentPicker {

//    MARK: - Properties
    
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
        self.navigationController?.navigationBar.isHidden = false
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
      
    func saveBackupToFile(password: String){
        
        //TODO: add error message
        guard let backupData = Backup.getEncriptedData(password: password) else {return}
        
        let temporaryFolder = FileManager.default.temporaryDirectory
        let temporaryFilePath = temporaryFolder.appendingPathComponent("sotpbackup.sotp")

        do{
            try backupData.write(to: temporaryFilePath, atomically: true, encoding: .utf8)
            let activityViewController = UIActivityViewController(activityItems: [temporaryFilePath], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        
    }
 
    
    func getPassword(completion: @escaping (String?) -> () ){
        let passwordViewController = PasswordViewController()
        passwordViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController: passwordViewController, animated: true, completion: {
                passwordViewController.callBack = completion
        })
    }
    
            
//    MARK: - Handlers
    @objc func handleSaveToBackup(){
        print(#function)
        getPassword { [weak self ](pass) in
            if let pass = pass{
                self?.saveBackupToFile(password: pass)
            }
        }
    }
    
    @objc func handleLoadFromBackup(){
        chooseDocument {(isEnded) in
            print ("isEnded")
        }
    }
    
}
