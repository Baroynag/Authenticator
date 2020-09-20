//
//  Exrentions.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 05.01.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import CoreData

enum States{
    case view
    case edit
    case add
}

extension UIColor{

    static func fucsiaColor() -> UIColor{
       return UIColor(red: 1, green: 0.196, blue: 0.392, alpha: 1)
    }
    
}

extension AuthenticatorViewController: AddItemDelegate {
    func createNewItem(account: String?, issuer: String?, key: String?, timeBased: Bool) {
        AuthenticatorModel.shared.addOneItem(account: account, issuer: issuer, key: key, timeBased: timeBased)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension AuthenticatorViewController: RefreshTableDelegate {
    func refresh() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
}

extension UIViewController{
    func setupNavigationController(){
        let font = UIFont(name: "Lato-Light", size: 24)
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        var navTextColor = UIColor()
        if traitCollection.userInterfaceStyle == .light {
            navTextColor = UIColor.black
        } else { navTextColor = UIColor.white}
        
        appearance.titleTextAttributes = [.foregroundColor: navTextColor, .font: font!]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        self.navigationController?.navigationBar.tintColor = navTextColor
    }
}

extension UILabel{
    
    func setLabelAtributedText(fontSize: CGFloat, text: String, aligment: NSTextAlignment, indent: CGFloat){
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: .light)
    
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment
        paragraphStyle.firstLineHeadIndent = indent

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        self.attributedText =  attributedText

    }
    
    func setLabelAtributedText(fontSize: CGFloat, text: String, aligment: NSTextAlignment, indent: CGFloat, color: UIColor){
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment
        paragraphStyle.firstLineHeadIndent = indent

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        self.attributedText =  attributedText

    }
    
    
}


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
