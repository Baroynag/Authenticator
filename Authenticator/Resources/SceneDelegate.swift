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
        guard let winScene = (scene as? UIWindowScene) else { return }
        let navController = UINavigationController(rootViewController: AuthenticatorViewController())
        let rootScreen = AuthenticatorViewController()
        navController.viewControllers = [rootScreen]
        if !AuthenticatorModel.shared.isAnyRecords() {
            let greetingScreen = GreetingViewController()
            greetingScreen.delegate = self
            navController.viewControllers = [rootScreen, greetingScreen]
        }
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = navController
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

}

extension SceneDelegate: GreetingViewControllerDelegate {

    func didTapCreate() {
        window?.rootViewController = UINavigationController(rootViewController: AuthenticatorViewController())
    }

}
