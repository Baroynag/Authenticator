//
//  WatchAppConnection.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 02.06.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchAppConnection: NSObject{
    
    static let shared = WatchAppConnection()
    private let session = WCSession.default
    
    
    override init() {
        super.init()
        print("init")
        if isSuported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    private func sendDataToWatch(){
        print ("sendDataToWatch")
        if WCSession.isSupported(){
            do{
                let dictionary: [String: String] = ["test" : "123456"]
                try session.updateApplicationContext(dictionary)
            } catch{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    

}


extension WatchAppConnection: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if let error = error{
            fatalError("Can't activate session: \(error.localizedDescription)")
        }
        print("Iphone Session activated with status \(activationState.rawValue)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print (#function)
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print (#function)
        self.session.activate()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("iPhone didReceiveApplicationContext")
        if let watchAwakeAt = applicationContext["watchAwakeAt"] as? Double{
            print("watchAwakeAt = \(watchAwakeAt)")
            sendDataToWatch()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
         
         if let watchAwakeAt = message["watchAwake"] as? Double{
            print ("iPhone watchAwakeAt\(watchAwakeAt)")
            replyHandler(["vk" :  "12345"])
        }
    }

}
 
