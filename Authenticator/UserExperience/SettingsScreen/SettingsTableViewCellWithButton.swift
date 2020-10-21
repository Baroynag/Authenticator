//
//  SettingsTableViewCellWithButton.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class SettingsTableViewCellWithButton: UITableViewCell {

    var delgate: pressPurchaseDelegate?
    
    public var title: String?{
        didSet{
            if let title = title{
                purchaseButton.setTitle(NSLocalizedString(title, comment: "") , for: .normal)
               
            }
        }
    }
    let purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handlePurchase), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupView(){
        
        contentView.backgroundColor = .systemBackground
        
        purchaseButton.addTarget(self, action: #selector(handlePurchase), for: .touchUpInside)
        
        addSubview(purchaseButton)
        NSLayoutConstraint.activate([
         
            purchaseButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            purchaseButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            purchaseButton.heightAnchor.constraint(equalToConstant: 50),
            purchaseButton.widthAnchor.constraint(equalToConstant: 280)
            ])
    }
    
    @objc func handlePurchase(){
        self.delgate?.pressPurchaseButton()
    }
    
}
