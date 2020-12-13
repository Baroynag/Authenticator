//
//  UINavigationController+Completions.swift
//  Authenticator
//
//  Created by Alexandr on 13.12.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

extension UINavigationController {

    public func pushViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
  }

    func popViewController(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}
