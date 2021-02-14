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
import OneTimePassword

class InterfaceController: WKInterfaceController {

    // MARK: Properties
    private var countDown = 30
    private var timer: Timer?

    let context =  (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext

    @IBOutlet var table: WKInterfaceTable!
    private var session = WCSession.default

    private var persistentTokenItems = [SOTPPersistentToken]()

// MARK: functions

    override func didAppear() {
        super.didAppear()
        countDown = getTimerInterval()
        table.setNumberOfRows(1, withRowType: "SotpWRow")
        if let row = table.rowController(at: 0) as? SOTPWatchRow {
            row.passLabel?.setText(NSLocalizedString("Loading...", comment: ""))
        }
        print ("persistentTokenItems.count \(persistentTokenItems.count)")
        if persistentTokenItems.count != 0 {
            setupTable()
        }

    }

    override func willActivate() {
        super.willActivate()
        prepareSendMessage()
        startTimer()
        loadDataFromWatchKeychain()
    }

    private func updateTable() {

        if persistentTokenItems.count == 0,
           let row = table.rowController(at: 0) as? SOTPWatchRow {
            let text = NSLocalizedString("No accounts", comment: "")
            row.passLabel?.setText(text)
            return
        }

        table.setNumberOfRows(persistentTokenItems.count, withRowType: "SotpWRow")

        for (index, item) in persistentTokenItems.enumerated() {

            if let row = table.rowController(at: index) as? SOTPWatchRow {

                let token = persistentTokenItems[index]
                if let tokenPass = token.token?.currentPassword {
                    row.accountLabel.setText(item.token?.issuer)
                    row.passLabel.setText(tokenPass)
                    row.detailLabel.setText("Refresh in " + String(countDown) + "s.")
                }
            }
        }
    }

    private func getTimerInterval() -> Int {

        let count = Int(NSDate().timeIntervalSince1970) % 30
        return 30 - count
    }

    private func startTimer() {
        createTimer()
    }

    private func setupTable() {
        runUpdateTable()
    }

    private func runUpdateTable() {

        DispatchQueue.main.async {
            self.updateTable()
        }
    }

// MARK: Handlers

    @objc private func updateLabel () {
        if persistentTokenItems.count == 0 { return}

        countDown -= 1
        let text = "Refresh in " + String(countDown) + " s."
        for index in 0...persistentTokenItems.count - 1 {
            
            if let row = table.rowController(at: index) as? SOTPWatchRow {
                row.detailLabel.setText(text)
            }
        }

        if countDown == 0 {
            countDown = 30
            updateTable()
        }
    }
}

extension InterfaceController {

    func prepareSendMessage() {

        let timestamp = NSDate().timeIntervalSince1970
        let dictionary: [String: Double] = ["watchAwake": timestamp]

        sendMessage(dictionary) { [weak self] (response) in
            self?.syncDataWithPhone(responce: response)
            self?.setupTable()
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
                                if nsError.domain == "WCErrorDomain"  && availableRetries > 0 {
                                    availableRetries -= 1
                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + 0.3,
                                        execute: {trySendingMessageToWatch(message)})
                                    } else {errorHandler?(error)}
            })
        }
        trySendingMessageToWatch(message)
    }

}

extension InterfaceController{

    func syncDataWithPhone(responce: [String: Any]) {

        if !needUpdateDataInWatchKeyChain(responce: responce) {
            return
        }

        deleteDataFromKeyChain()
        persistentTokenItems = []
        for authItem in responce {
            if let responceItem = authItem.value as? [String: String] {
                
                let priority    = Int(responceItem["priority"] ?? "") ?? 0

                let key = responceItem["key"] ?? ""
                let issuer = responceItem["issuer"] ?? ""
                let account = responceItem["name"] ?? ""
                
                if let persistentToken = TokenGenerator.shared.createTimeBasedPersistentToken(name: account, issuer: issuer, secretString: key, priority: priority) {
                    persistentTokenItems.append(persistentToken)
                    persistentTokenItems = persistentTokenItems.sorted(by: { $0.priority ?? 0 < $1.priority ?? 0 })
                }

            }
        }

    }

    func deleteDataFromKeyChain(){
        if persistentTokenItems.count > 0 {
           for item in persistentTokenItems {
                if let identifier = item.identifier {
                    try? SOTPKeychain.shared.deleteKeychainItem(forPersistentRef: identifier)
                }
            }
        }
        
    }
    
    func loadDataFromWatchKeychain(){
        if let tokens = try? Array(SOTPKeychain.shared.allPersistentTokens()) {
            persistentTokenItems = tokens.sorted(by: { $0.priority ?? 0 < $1.priority ?? 0 })
        }
    }
    
    private func needUpdateDataInWatchKeyChain(responce: [String: Any]) -> Bool{
    
        
        if responce.count == 0 {
            return false
        }
        
        if responce.count != persistentTokenItems.count {
            return true
        }
        var needUpdate: Bool = false
 
        LOOP: for authItem in responce {
            if let responceItem = authItem.value as? [String: String] {
                let priority    = Int(responceItem["priority"] ?? "")

                for watchitem in persistentTokenItems {
                    needUpdate =
                        watchitem.plainSecret != responceItem["key"] ||
                        watchitem.token?.issuer != responceItem["issuer"] ||
                        watchitem.token?.name != responceItem["name"] ||
                        watchitem.priority != priority

                    if needUpdate {
                        break LOOP
                    }
                }
            }
        }
        return needUpdate
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
