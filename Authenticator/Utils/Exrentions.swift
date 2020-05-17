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
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func fucsiaColor() -> UIColor{
       return UIColor(red: 1, green: 0.196, blue: 0.392, alpha: 1)
    }
    
}


extension AuthenticatorViewController: AddItemDelegate {
    func createNewItem(newAuthItem: Authenticator) {

        AuthenticatorModel.shared.addOneItem(newAuthItem: newAuthItem)
        tableView.reloadData()

    }
}

extension RowDetailViewController: AuthenticatorViewControllerDelegate {
    func setEditedText(text: String?, state: States) {
        guard let text = text else {return}
        editedText = text
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
        self.navigationController?.navigationBar.tintColor = UIColor.systemBlue
    }
}

extension UILabel{
    
    func setLabelAtributedText(fontSize: CGFloat, text: String, aligment: NSTextAlignment, indent: CGFloat){
        
        let font = UIFont(name: "Lato-Light", size: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment
        paragraphStyle.firstLineHeadIndent = indent

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        self.attributedText =  attributedText

    }
    
}

