//
//  UIButton+SOTPShadows.swift
//  Authenticator
//
//  Created by Alexandr on 24.02.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func sotpShadow() {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 25).cgPath
        shadowLayer.fillColor = UIColor.fucsiaColor.cgColor
        
        shadowLayer.shadowColor = CGColor(srgbRed: 1, green: 0.2, blue: 0.39, alpha: 0.3)
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 12
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
}
