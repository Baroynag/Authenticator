//
//  IphoneAppConnection.swift
//  SOTPWatch Extension
//
//  Created by Anzhela Baroyan on 03.06.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//
/*
import WatchKit
import WatchConnectivity

class IphoneAppConnection: NSObject {
    
    static let shared = IphoneAppConnection()
    private let session = WCSession.default
    
    override init() {
        super.init()
        
        if isSuported() {
            session.delegate = self
            session.activate()
        }
        
        
    }
    
    func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    func sendDataToIphone(){

        /*Передаем данные на телефон*/
            do{
                
                let timestamp = NSDate().timeIntervalSince1970
                let dictionary: [String: Double] = ["watchAwakeAt": timestamp]
                try session.updateApplicationContext(dictionary)
            } catch
            {
                print ("Watch update context error: \(error.localizedDescription)")
            }
    }

}

extension IphoneAppConnection: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
                
        if let error = error{
            fatalError("Can't activate session: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        //Получаем данные от телефона
        SOTPWatchModel.shared.authList = applicationContext
    }
     
}
 
*/
