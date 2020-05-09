//
//  AuthenticatorViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//


import UIKit
import CoreData

class AuthenticatorViewController: UITableViewController {
  
//    MARK: - Properties
    var authList: [NSManagedObject] = []
    
    let cellId = "cellId"
    
   weak var delegate_test: AuthenticatorViewControllerDelegate?

//    MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

//    MARK: - Handlers
    @objc func pressAddButton(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Scan barcode", style: .default) { _ in
            
            self.pushScanQrViewController()
        })

        alert.addAction(UIAlertAction(title: "Add manually", style: .default) { _ in
            self.pushDetailViewController(text: nil, state: .add)
        })

        present(alert, animated: true)
        
//
    }

//    MARK: - Functions
   
    private func configureTableView() {
      
        setupNavigationController()
        navigationItem.title = "Authenticator"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAddButton))
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func pushDetailViewController(text: String?, state: States){
        
        let rowDetailViewController = RowDetailViewController()
        
        delegate_test = rowDetailViewController
        delegate_test?.setEditedText(text: text, state: state)
        rowDetailViewController.delegate = self
        
        navigationController?.pushViewController(rowDetailViewController, animated: true)
    }
    
    private func pushScanQrViewController(){
        
        let scanQrViewController = ScanQrViewController()
        scanQrViewController.delegate = self
        navigationController?.pushViewController(scanQrViewController, animated: true)
    }
    
    private func fetchData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchREquest = NSFetchRequest<NSManagedObject>(entityName: "AuthenticationList")
        do{
            authList = try managedContext.fetch(fetchREquest)
        } catch let error as NSError{
            print ("Failed to fetch items ", error)
        }
    }
    
}

// Extentions for table view

extension AuthenticatorViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return authList.count
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell

            if let account = authList[indexPath.row].value(forKey: "account") as? String,
                let key = authList[indexPath.row].value(forKey: "key")  as? String,
                let timeBased = authList[indexPath.row].value(forKey: "timeBased") as? Bool
                {
                    var authItem = Authenticator()
                    authItem.account = account
                    authItem.key = key
                    authItem.timeBased = timeBased
                    cell.authItem = authItem
               }
            
        return cell
    }
        
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        if editingStyle == .delete {
          
            guard let account = authList[indexPath.row].value(forKey: "account") as? String
                else { return}
           
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthenticationList")

            request.predicate = NSPredicate(format:"account = %@", account as CVarArg)

            let result = try? context.fetch(request)
            let resultData = result as! [NSManagedObject]

            for object in resultData {
                context.delete(object)
            }

            do {
                try context.save()
                print("TABLEVIEW-EDIT: saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                print("general error")
            }
     
            authList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    

}

