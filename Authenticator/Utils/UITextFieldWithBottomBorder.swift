//
//  UITextFieldWithBottomBorder.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.05.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class UITextFieldWithBottomBorder: UITextField {

    private let bottomBorder = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createBorder(textField: self, color: UIColor.systemGray2, borderWidth: 2.0, border: bottomBorder)
        
        self.layer.addSublayer(bottomBorder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createBorder(textField: UITextField, color: UIColor, borderWidth: CGFloat, border: CALayer) -> Void {
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0.0, y: textField.frame.size.height - borderWidth, width: textField.frame.size.width, height: borderWidth);
    }
    
    public func updateBorder(color: UIColor) -> Void {
        self.bottomBorder.backgroundColor = color.cgColor
    }
    
}
