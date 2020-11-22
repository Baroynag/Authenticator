//
//  InterfaceController.swift
//  SOTPWatch Extension
//
//  Created by Anzhela Baroyan on 01.06.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreData

class InterfaceController: WKInterfaceController {
    
    //    MARK: Properties
    private var countDown = 30
    private var timer: Timer?
    
    
    let context =  (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
   
    @IBOutlet var table: WKInterfaceTable!
    private var session = WCSession.default
    
    private var items = [AuthenticatorForWatchItem]()

    
//    MARK: functions
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("awake")
    }
 
    override func didAppear() {
        super.didAppear()
        self.countDown = self.getTimerInterval()
        setupTable()
        table.setNumberOfRows(1, withRowType: "SotpWRow")
        if let row = table.rowController(at: 0) as? SOTPWatchRow {
            row.passLabel?.setText("Загрузка...")
        }
    }
    
    override func willActivate() {
        super.willActivate()
        print("willActivate")
        prepareSendMessage()
        startTimer()
    }
    
    
    private func updateTable() {
        table.setNumberOfRows(items.count, withRowType: "SotpWRow")
        for (i, item) in items.enumerated() {
            if let row = table.rowController(at: i) as? SOTPWatchRow {
                
                let token = TokenGenerator.shared.createToken(name: "", issuer: item.issuer ?? "", secretString: item.key ?? "")
                if let tokenPass = token?.currentPassword{
                    row.accountLabel?.setText(item.key)
                    row.passLabel?.setText(tokenPass)
                    row.detailLabel?.setText("Refresh in " + String(countDown) + "s.")
                }
            }
        }
    }
    
    private func getTimerInterval() -> Int {
        
        let count = Int(NSDate().timeIntervalSince1970) % 30
        return 30 - count
    }
    
    
    private func startTimer(){
        createTimer()
    }
    
    private func setupTable(){
        
        self.fetchData()
        
        runUpdateTable()
    }
    
    private func runUpdateTable(){
        
        DispatchQueue.main.async {
            self.updateTable()
        }
    }
    
//    MARK: Handlers
     
    @objc private func updateLabel (){
        if items.count == 0 { return}
        
        countDown -= 1
        let text = "Refresh in " + String(countDown) + " s."
        for i in 0...items.count - 1 {
            if let row = table.rowController(at: i) as? SOTPWatchRow {
                row.detailLabel.setText(text)
            }
        }

        if countDown == 0 {
            countDown = 30
            updateTable()
        }
    }
}

extension InterfaceController{
    
    
    func prepareSendMessage() {

        let timestamp = NSDate().timeIntervalSince1970
        let dictionary: [String: Double] = ["watchAwake": timestamp]

        sendMessage(dictionary) { [weak self] (response) in
            self?.saveResponceToCoreData(responce: response)
            self?.setupTable()
        } errorHandler: { (error) in
            print("Error sending message: %@", error)
        }
    }
    
    
    func sendMessage(_ message: [String: Double], replyHandler: (([String: Any]) -> Void)?, errorHandler: ((Error) -> Void)?) {
        
        let maxNrRetries = 5
        var availableRetries = maxNrRetries

        func trySendingMessageToWatch(_ message: [String: Double]) {
            session.sendMessage(message,
                replyHandler: replyHandler,
                errorHandler: { error in
                                print("sending message to watch failed: error: \(error)")
                                let nsError = error as NSError
                                if nsError.domain == "WCErrorDomain" &&
                                    nsError.code == 7007 && availableRetries > 0 {
                                        availableRetries = availableRetries - 1
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {trySendingMessageToWatch(message)})
                                    } else {errorHandler?(error)}
            })
        }
        trySendingMessageToWatch(message)
    }
   
}


extension InterfaceController{
    
    func fetchData() {
        
        let request = NSFetchRequest<AuthenticatorForWatchItem>(entityName: "AuthenticatorForWatchItem")
        self.items = []
        
        do{
            self.items = try context.fetch(request)
        } catch{
            print(NSLocalizedString("Core data load error", comment: "") ,  error.localizedDescription)
        }
    }
    
    
    func deleteData(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AuthenticatorForWatchItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print(NSLocalizedString("Core data delete error", comment: "") ,  error.localizedDescription)
        }
          
    }
    
    func saveResponceToCoreData(responce: [String: Any]){
        
        deleteData()
        
        for (_, item) in responce.enumerated() {
            let newItem = AuthenticatorForWatchItem(context: context)
            newItem.account = ""
            newItem.id = UUID()
            newItem.issuer = item.value as? String
            newItem.key = item.key
            
            do{
                try self.context.save()
                print("saved")
            } catch{
                print(NSLocalizedString("Core data save error", comment: "") ,  error.localizedDescription)
            }
              
        }
    }

}


extension InterfaceController {

    private func createTimer() {
        
        if timer == nil {
            
            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(updateLabel),
                              userInfo: nil,
                              repeats: true)
            
            RunLoop.current.add(timer, forMode: .common)
           
            timer.tolerance = 0.1
      
            self.timer = timer
        }
    }
  
   
    
}
