//
//  WatchAppConnection.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 02.06.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchAppConnection: NSObject {

    static let shared = WatchAppConnection()
    private let session = WCSession.default

    override init() {
        super.init()

        if isSuported() {
            session.delegate = self
            session.activate()
        }
        print("session.isPaired = \(session.isPaired)")
        print("session.isReachable = \(session.isReachable)")
    }

    func isSuported() -> Bool {
        return WCSession.isSupported()
    }

}

extension WatchAppConnection: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {

        if let error = error {
            fatalError("Can't activate session: \(error.localizedDescription)")
        }
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String: Any],
                 replyHandler: @escaping ([String: Any]) -> Void) {

        if (message["watchAwake"] as? Double) != nil {
            let dictionary = AuthenticatorModel.shared.loadDataForWatch()
            replyHandler(dictionary)
        }
    }

}
