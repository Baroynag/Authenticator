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

class InterfaceController: WKInterfaceController {
    
    //    MARK: Properties
    @IBOutlet var table: WKInterfaceTable!
    private var session = WCSession.default
    
    private var items = [String: Any]() {
        didSet {
            DispatchQueue.main.async {
                self.updateTable()
            }
        }
    }
    
//    MARK: functions
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("awake")
//        items.updateValue("start", forKey: "000000")
    }
 
    override func didAppear() {
        super.didAppear()
        print(#function)
        sendMessage()
    }
    
    override func willActivate() {
        super.willActivate()
        print("willActivate")
        if isSuported() {
            session.delegate = self
            session.activate()
        }
    }
 
    private func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    func sendMessage() {
        print("sendMessage")
        let timestamp = NSDate().timeIntervalSince1970
        let dictionary: [String: Double] = ["watchAwake": timestamp]
                       
        session.sendMessage(dictionary, replyHandler: { (response) in
            self.items = response
                print("response\(response)")
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
    }
    
    private func updateTable() {
        table.setNumberOfRows(items.count, withRowType: "SotpWRow")
        for (i, item) in items.enumerated() {
            if let row = table.rowController(at: i) as? SOTPWatchRow {
                row.accountLabel.setText(item.key)
                row.passLabel.setText(item.value as? String)
            }
        }
    }
    
//    MARK: Handlers
    
    @IBAction func tapUpdateButton() {
//        sendMessage()
    }

}


/*protocol SyncWithPhoneDelegate {
    func syncWithPhone(syncValue: [String : Any]) 
}


extension InterfaceController: SyncWithPhoneDelegate{
    func syncWithPhone(syncValue: [String : Any]) {
        print ("syncWatch")
//        var index = 0
//        for (account, key) in SOTPWatchModel.shared.authList{
//            guard let row = table?.rowController(at: index) as? SOTPWatchRow else {continue}
//            row.accountLabel.setText(account)
//            if let key = key as? String{
//                row.passLabel.setText(key)
//
//            }
//            index += 1
//        }
    }
   
}*/



extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState.rawValue) error:\(String(describing: error))")
    }
    
}
