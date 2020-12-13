//
//  SceneDelegate.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 10.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        if AuthenticatorModel.shared.isAnyRecords() {
           showAuthenticatorRoot()
        } else {
            showGreetingRoot()
        }
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    private func showGreetingRoot() {
        let greetingScreen = GreetingViewController()
        greetingScreen.output = self
        window?.rootViewController = greetingScreen
    }
    
    private func showAuthenticatorRoot() {
        let authenticatorViewController = AuthenticatorViewController()
        window?.rootViewController = UINavigationController(rootViewController: authenticatorViewController)
    }
}

extension SceneDelegate: GreetingViewControllerOutput {
    func didLoadBackup() {
        showAuthenticatorRoot()
    }
    
    func didAdd(account: String?, issuer: String?, key: String?) {
        showAuthenticatorRoot()
    }
}
