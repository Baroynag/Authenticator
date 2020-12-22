//
//  UILabel+AttributedText.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 13.12.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setAttributedText(
        fontSize: CGFloat,
        text: String,
        aligment: NSTextAlignment,
        indent: CGFloat) {
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
        self.attributedText = attributedText
    }

    func setAttributedText(fontSize: CGFloat,
                           text: String,
                           aligment: NSTextAlignment,
                           indent: CGFloat,
                           color: UIColor) {
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

    func setAttributedText(text: String,
                           fontSize: CGFloat,
                           aligment: NSTextAlignment,
                           indent: CGFloat,
                           color: UIColor,
                           fontWeight: UIFont.Weight) {

        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
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
