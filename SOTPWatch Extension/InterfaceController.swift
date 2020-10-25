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
    private var countDown = 30
    private var timer: Timer?
    
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
    }
 
    override func didAppear() {
        super.didAppear()
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
                row.accountLabel?.setText(item.key)
                row.passLabel?.setText(item.value as? String)
                row.detailLabel?.setText("Oбновится через 30с.")
            }
        }
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
//    MARK: Handlers
    
    
    @objc private func updateLabel (){
        if items.count == 0 { return}
        countDown -= 1
        let text = "Oбновится через " + String(countDown) + "с."
        for i in 0...items.count - 1 {
            if let row = table.rowController(at: i) as? SOTPWatchRow {
                row.detailLabel.setText(text)
            }
        }

        if countDown == 0 {
            countDown = 30
            prepareSendMessage()
        }
    }
}

extension InterfaceController{
    
    
    func prepareSendMessage() {

        let timestamp = NSDate().timeIntervalSince1970
        let dictionary: [String: Double] = ["watchAwake": timestamp]

        sendMessage(dictionary) { (response) in
            self.items = response
            print (response)
        } errorHandler: { (error) in
            print("Error sending message: %@", error)
        }
    }
    
    
    func sendMessage(_ message: [String: Double],
                                     replyHandler: (([String: Any]) -> Void)?,
                                     errorHandler: ((Error) -> Void)?) {
        
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


