//
//  AuthenticatorViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//


import UIKit
import CoreData

class AuthenticatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
//    MARK: - Properties
    
    let cellId = "cellId"
    var tableView = UITableView()
   
    let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addButton"), for: .normal)
        button.addTarget(self, action: #selector(pressAddButton), for: .touchUpInside)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        return button
    }()

//    MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        createTable()
        setupAddButton()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     }

//    MARK: - Handlers
    @objc func pressAddButton(){
        self.pushDetailViewController(text: nil, state: .add)
    }

//    MARK: - Functions
    func createTable(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }
    
    private func setupAddButton(){
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            addButton.heightAnchor.constraint(equalToConstant: 80),
            addButton.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    
    private func configureNavBar() {
        setupNavigationController()
        navigationItem.title = "Authenticator"

    }
    
    private func pushDetailViewController(text: String?, state: States){
        let rowDetailViewController = RowDetailViewController()
        
        rowDetailViewController.delegate = self
        rowDetailViewController.modalPresentationStyle = .fullScreen
        self.present(rowDetailViewController, animated: true, completion: nil)
    }
    
    private func fetchData(){
        AuthenticatorModel.shared.loadData()
    }
    
}


//    MARK: - UITableViewDataSource
extension AuthenticatorViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthenticatorModel.shared.authList.count
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell
        
        let item = AuthenticatorModel.shared.authList[indexPath.row]

//        TODO: refactor
//
        if  let account = item.value(forKey: "account") as? String,
            let key = item.value(forKey: "key")  as? String,
            let issuer = item.value(forKey: "issuer") as? String,
            let timeBased = item.value(forKey: "timeBased") as? Bool
        {
            var authItem = Authenticator()
            authItem.account = account
            authItem.key = key
            authItem.issuer = issuer
            authItem.timeBased = timeBased
            cell.authItem = authItem
        }
        
        cell.copyButton.tag = indexPath.row
        cell.delgate = self
        return cell
    }
}

//    MARK: - UITableViewDelegate
extension AuthenticatorViewController{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        if editingStyle == .delete {
            AuthenticatorModel.shared.deleteData(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
        
    }
 
}



extension AuthenticatorViewController: CopyPassToClipBoardDelegate {
    
    func pressCopyButton(otp: String) {
        print ("otp = \(otp)")
        let pasteboard = UIPasteboard.general
        pasteboard.string = otp
    }

}
