//
//  RoundedButtonWithShadow.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 19.09.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation
import UIKit

final class RoundedButtonWithShadow: UIButton {

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
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

}
