//
//  UIViewController+SetupNavigation.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 13.12.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavigationController() {
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        var navTextColor = UIColor()
        if traitCollection.userInterfaceStyle == .light {
            navTextColor = UIColor.black
        } else { navTextColor = UIColor.white}
        appearance.titleTextAttributes = [.foregroundColor: navTextColor, .font: font]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = navTextColor
    }
}
