//
//  CustomCell.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCell: UITableViewCell {
    
    // MARK: - Properties
    private var countDown = 30
    private var key = ""
    private var issuer = ""
    private var account = ""
    private var copyCountDown = 0
    private var isCopyCountPressed = false
    var passLabelText = ""
    
    var delgate: CopyPassToClipBoardDelegate?
    
    public var authItem: AuthenticatorItem?{
        didSet{
            guard let authItem = authItem else {return}
            let authKey = authItem.key ?? ""
            let authIssuer = authItem.issuer ?? ""
            let account = authItem.account ?? ""

            key = authKey
            issuer = authIssuer
            
            issuerLabel.setLabelAtributedText(fontSize: 24, text: authIssuer, aligment: .center, indent: 0.0)
            
            accountLabel.setLabelAtributedText(fontSize: 16, text: account, aligment: .center, indent: 0.0, color: .fucsiaColor())
            
            let token = TokenGenerator.shared.createToken(name: authIssuer, issuer: authIssuer, secretString: authKey)
            
            if let keyText = token?.currentPassword{
                passLabelText = keyText
                passLabel.setLabelAtributedText(fontSize: 48, text: keyText,  aligment: .center, indent: 0.0)
            }
            
            updateTimerInfoLabel()
        }
    }
    
    private let issuerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let passLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Refresh in 30 s.", comment: "")
        label.setLabelAtributedText(fontSize: 16, text: text, aligment: .center, indent: 0.0)
        return label
    }()
    
    let copyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "copyButton"), for: .normal)
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
 
    // MARK: - Functions
    
    private func setupView(){
        contentView.backgroundColor = .systemBackground
        
        addSubview(issuerLabel)
        NSLayoutConstraint.activate([
            issuerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            issuerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            issuerLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            issuerLabel.heightAnchor.constraint(equalToConstant: 28)
            ])
        
        addSubview(passLabel)
        NSLayoutConstraint.activate([
            passLabel.topAnchor.constraint(equalTo: issuerLabel.bottomAnchor, constant: 8),
            passLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            passLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            passLabel.heightAnchor.constraint(equalToConstant: 48)
         ])
        
        addSubview(accountLabel)
        
        NSLayoutConstraint.activate([
            accountLabel.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 8),
            accountLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            accountLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            accountLabel.heightAnchor.constraint(equalToConstant: 24)
            ])
        
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
         ])
        
        copyButton.addTarget(self, action: #selector(handleCopyButton), for: .touchUpInside)
        addSubview(copyButton)
        NSLayoutConstraint.activate([
            copyButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            copyButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant:  -16),
            copyButton.heightAnchor.constraint(equalToConstant: 32),
            copyButton.widthAnchor.constraint(equalToConstant: 32)
         ])

    }
    
    private func startCopy(){
        copyCountDown = 5
        isCopyCountPressed = true
        passLabel.setLabelAtributedText(fontSize: 40, text: "Copied",  aligment: .center, indent: 0.0)
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    private func endCopy(){
        copyCountDown = 0
        isCopyCountPressed = false
        passLabel.setLabelAtributedText(fontSize: 48, text: passLabelText,  aligment: .center, indent: 0.0)
    }
    
    // MARK: - Handlers
    
    @objc public func updateTimerInfoLabel (){
        countDown -= 1
        descriptionLabel.text = NSLocalizedString("Refresh in ", comment: "") + String(countDown) + NSLocalizedString("s.", comment: "")
        
        if isCopyCountPressed{
            copyCountDown -= 1
            if copyCountDown == 0 {
                endCopy()
            }
        }
        
        if countDown == 0 {
            countDown = 30
            let token = TokenGenerator.shared.createToken(name: issuer, issuer: issuer, secretString: key)
            if let text = token?.currentPassword {
                passLabel.setLabelAtributedText(fontSize: 50, text: text,  aligment: .center, indent: 0.0)
                passLabelText = text
            }
        }
        
        
    }
    
    @objc private func handleCopyButton(){
       
        if let otp = passLabel.text {

            startCopy()
                
            delgate?.pressCopyButton(otp: otp)
        }
    }

}
