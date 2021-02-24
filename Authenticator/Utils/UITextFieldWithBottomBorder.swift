//
//  UITextFieldWithBottomBorder.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 17.05.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class UITextFieldWithBottomBorder: UITextField {
    
    private var bottomBorder: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBorder(color: UIColor) {
        bottomBorder?.backgroundColor = color.cgColor
    }
    
    private func createBottomBorder() {
        bottomBorder = CALayer()
        bottomBorder?.backgroundColor = UIColor.graySOTPColor.cgColor
        bottomBorder?.frame = CGRect(
            x: 0.0,
            y: frame.size.height - Constants.borderHeight,
            width: frame.size.width,
            height: Constants.borderHeight)
        self.layer.addSublayer(bottomBorder!)
    }
    
    private enum Constants {
        static let borderHeight: CGFloat = 1.5
    }
}
