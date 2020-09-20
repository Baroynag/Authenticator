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
            shadowLayer.fillColor = UIColor.fucsiaColor().cgColor

            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2

            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }

}
