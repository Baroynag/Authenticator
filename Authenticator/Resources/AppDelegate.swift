//
//  AppDelegate.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 10.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !WatchAppConnection.shared.isSuported() {
            print("WCSession not supported")
        }
        iapSetup()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    func iapSetup() {
        Purchases.default.initialize { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success:
                print("success")
            default:
                print("default")
            }
        }
    }

}
