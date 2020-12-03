//
//  AuthenticatorViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//


import UIKit

class AuthenticatorViewController: UIViewController {
  
//    MARK: - Properties
    
    let cellId = "cellId"
    var tableView = UITableView()
    var timer: Timer?
    
    private let addButton: UIButton = {
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
        createTable()
        setupAddButton()
        createTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }

//    MARK: - Handlers
    @objc private func pressAddButton(){
        
      self.pushDetailViewController(text: nil, state: .add)
    }

    @objc private func settingsTapped(){
        let settingsViewController = SettingsTableViewController()
        settingsViewController.modalPresentationStyle = .fullScreen
        settingsViewController.refreshTableDelegate = self
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @objc private func editTapped(){
        
        for cell in tableView.visibleCells {
            
            if let customCell = cell as? CustomCell {
                
                if !tableView.isEditing {
                    let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editTapped))
                    navigationItem.leftBarButtonItem = saveButton
                    
                    addButton.isHidden = true
                    customCell.startEditing()
                } else {
                    let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
                    navigationItem.leftBarButtonItem = editButton
                    addButton.isHidden = false
                    customCell.stopEditing()
                    AuthenticatorModel.shared.endEditing() 
                }
            }
        }
        
        tableView.isEditing  = !tableView.isEditing
        
    }
    
//    MARK: - Functions
    private func createTable(){
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
        navigationItem.title =  NSLocalizedString("Authenticator", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsTapped))
        settingsButton.tintColor = UIColor.label
       
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))

        editButton.tintColor = UIColor.label
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = settingsButton
        
    }
    
    private func pushDetailViewController(text: String?, state: States){
        let addAccountViewController = AddAccountViewController()
        addAccountViewController.refreshTableDelegate = self
        self.present(addAccountViewController, animated: true)
    }
    
}


//    MARK: - UITableViewDataSource
extension AuthenticatorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthenticatorModel.shared.authenticatorItemsList?.count ?? 0
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell
        
        if let item = AuthenticatorModel.shared.authenticatorItemsList?[indexPath.row]{
            cell.authItem = item
            cell.copyButton.tag = indexPath.row
        }

        return cell
    }
}

//    MARK: - UITableViewDelegate
extension AuthenticatorViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        if editingStyle == .delete {
            AuthenticatorModel.shared.deleteData(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let cell = tableView.cellForRow(at: indexPath) as? CustomCell {
        cell.copyToClipBoard()
      }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        AuthenticatorModel.shared.swapPriority(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
            
    }
 
}


// MARK: - Timer
extension AuthenticatorViewController {

    private func createTimer() {
        
        if timer == nil {
            
            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)
            
            RunLoop.current.add(timer, forMode: .common)
           
            timer.tolerance = 0.1
      
            self.timer = timer
        }
    }
  
    @objc func updateTimer() {
    
        guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
    
        for indexPath in visibleRowsIndexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? CustomCell {
                cell.updateTimerInfoLabel()
            }
        }
    }
    
}

extension AuthenticatorViewController: RefreshTableDelegate {
    func refresh() {
      self.tableView.reloadData()
    }
    
}
