//
//  CustomLabel.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 18.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    public var attributes:[NSAttributedString.Key: Any]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        
        let font = UIFont(name: "Lato-Light", size: 24)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = 15.0

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]

        let attributedText = NSMutableAttributedString(string: "Label", attributes: attributes)
        self.attributes = attributes
        self.attributedText =  attributedText
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white

    }

}
