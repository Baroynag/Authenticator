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
    private let duration = 30
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
            row.passLabel.setText("Загрузка...")
            row.passLabel.setTextColor(UIColor.fucsiaColor())
        }
    }
    
    override func willActivate() {
        super.willActivate()
        print("willActivate")
        sendMessage()
        startTimer()
    }
    
    func sendMessage() {
        let timestamp = NSDate().timeIntervalSince1970
        let dictionary: [String: Double] = ["watchAwake": timestamp]
                       
        session.sendMessage(dictionary, replyHandler: { (response) in
            self.items = response
            
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
                row.passLabel.setTextColor(UIColor.fucsiaColor())
                row.detailLabel.setText("Действителен 30 с.")
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
        let text = "Действителен " + String(countDown) + "с."
        for i in 0...items.count - 1 {
            if let row = table.rowController(at: i) as? SOTPWatchRow {
                row.detailLabel.setText(text)
            }
        }

        if countDown == 0 {
            countDown = 30
            sendMessage()
        }
    }
}

extension UIColor{
    static func fucsiaColor() -> UIColor{
       return UIColor(red: 1, green: 0.196, blue: 0.392, alpha: 1)
    }
    
}
