//
//  SettingsTableViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    

    weak var refreshTableDelegate: RefreshTableDelegate?
    
    let cellId = "settingsCellId"
    let cellWithButtonId = "settingsCellWithButtonId"
    
    let settingsList = [
    "Support this project",
    "Create backup",
    "Load from Backup",
    "Privacy policy",
    "License agreement"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SettingsTableViewCellWithButton.self, forCellReuseIdentifier: cellWithButtonId)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        setupView()
    }
    

    private func setupView(){
        setupNavigationController()
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        view.backgroundColor = UIColor.systemBackground
           
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numbersOfRows = 0
        if section == 0{
            numbersOfRows = 1
        } else {
            numbersOfRows = 4
        }
        return numbersOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        if indexPath.section == 0{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: cellWithButtonId, for: indexPath) as! SettingsTableViewCellWithButton
            cell.title = settingsList[indexPath.row]
            cell.delgate = self
            cell.purchaseButton.tag = indexPath.row 
          
            return cell
            
        } else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.title = settingsList[indexPath.row + 1]
            
            return cell
            
            
        }
        
        
    }
   
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        if section == 1{
            if traitCollection.userInterfaceStyle == .light {
                vw.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
            } else{
                vw.backgroundColor =   UIColor(red: 0.158, green: 0.158, blue: 0.158, alpha: 1)
            }
        }
        return vw
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 80
        } else {
            return 44
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            return
        }
        
        if indexPath.row == 0{
            print ("create backup")
            let passwordViewController = PasswordViewController()
            passwordViewController.modalPresentationStyle = .fullScreen
                   
            self.present(passwordViewController, animated: true)
            
        } else if indexPath.row == 1{
            
            self.chooseDocument(vcWithDocumentPicker: self) {
                    print("chooseDocument end")
            }
        } else if  indexPath.row == 2{
            print ("22")
        }  else if  indexPath.row == 3{
            print ("22")
        }
        
    }
   

}

extension SettingsTableViewController: pressPurchaseDelegate {
    func pressPurchaseButton() {
        let purchaseViewController = PurchaseViewController()
        self.present(purchaseViewController, animated: true, completion: nil)
    }
    
}


