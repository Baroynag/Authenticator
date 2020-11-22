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
    private var key = ""
    private var issuer = ""
    private var account = ""
    private var copyCountDown = 0
    private var isCopyCountPressed = false
    
    public var passLabelText = ""
    
    public var authItem: AuthenticatorItem?{
        didSet{
            guard let authItem = authItem else {return}
            let authKey = authItem.key ?? ""
            let authIssuer = authItem.issuer ?? ""
            let account = authItem.account ?? ""

            key = authKey
            issuer = authIssuer
            
            issuerLabel.setLabelAtributedText(text: authIssuer, fontSize: 18, aligment: .center, indent: 0.0, color: UIColor.label, fontWeight: .medium)
            
            accountLabel.setLabelAtributedText(text: account, fontSize: 16, aligment: .center, indent: 0.0, color: .fucsiaColor(), fontWeight: .light)
            
            
            let token = TokenGenerator.shared.createToken(name: authIssuer, issuer: authIssuer, secretString: authKey)
            
            if let keyText = token?.currentPassword{
                passLabelText = keyText
                setupPassLabelText(text: keyText)
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
        
        let font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: text, attributes: [.font: font])
        
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
            issuerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            issuerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            issuerLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            issuerLabel.heightAnchor.constraint(equalToConstant: 28)
            ])
        
        addSubview(passLabel)
        NSLayoutConstraint.activate([
            passLabel.topAnchor.constraint(equalTo: issuerLabel.bottomAnchor, constant: 16),
            passLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            passLabel.heightAnchor.constraint(equalToConstant: 48)
         ])
        
        addSubview(accountLabel)
        
        NSLayoutConstraint.activate([
            accountLabel.topAnchor.constraint(equalTo: passLabel.bottomAnchor),
            accountLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            accountLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            accountLabel.heightAnchor.constraint(equalToConstant: 24)
            ])
        
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
         ])

        copyButton.addTarget(self, action: #selector(handleCopyButton), for: .touchUpInside)
        addSubview(copyButton)
        NSLayoutConstraint.activate([
            copyButton.topAnchor.constraint(equalTo: issuerLabel.bottomAnchor),
            copyButton.leadingAnchor.constraint(equalTo: passLabel.trailingAnchor, constant: 8),
            copyButton.heightAnchor.constraint(equalToConstant: 32),
            copyButton.widthAnchor.constraint(equalToConstant: 32)
        ])

    }
    
    private func startCopy(){
        copyCountDown = 5
        isCopyCountPressed = true
        setupPassLabelText(text: "Copied")
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    private func endCopy(){
        copyCountDown = 0
        isCopyCountPressed = false
        setupPassLabelText(text: passLabelText)
    }
    
    private func setupPassLabelText (text: String){
        let font = UIFont.systemFont(ofSize: 50, weight: .thin)
        passLabel.textAlignment = .center
        passLabel.attributedText = NSMutableAttributedString(string: text, attributes: [.kern: 5.75, .font: font])
    }
    
    public func copyToClipBoard(){
        
        startCopy()
        let pasteboard = UIPasteboard.general
        pasteboard.string = passLabelText
        
    }
    
    // MARK: - Handlers
    
    @objc public func updateTimerInfoLabel (){
        let countDown = Int(NSDate().timeIntervalSince1970) % 30
        var timeLabel = String(30 - countDown)
        
        if countDown == 0 {
            timeLabel = "1"
        }
        descriptionLabel.text = NSLocalizedString("Refresh in ", comment: "") + timeLabel + NSLocalizedString("s.", comment: "")
        
        if isCopyCountPressed{
            copyCountDown -= 1
            if copyCountDown == 0 {
                endCopy()
            }
        }
        
        if countDown == 0 {
            
            let token = TokenGenerator.shared.createToken(name: issuer, issuer: issuer, secretString: key)
            if let text = token?.currentPassword {
                setupPassLabelText(text: text)
                passLabelText = text
            }
        }
        
        
    }
    
    @objc private func handleCopyButton(){
        copyToClipBoard() 
    }
    


}
