//
//  CustomCell.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import OneTimePassword
import Base32

class CustomCell: UITableViewCell {
    
    // MARK: - Properties
    private var countDown = 30
    private let duration = 30
    private var timer: Timer?
    private var key = ""
    private var issuer = ""
    
    public var authItem: Authenticator?{
        didSet{
            guard let authItem = authItem else {return}
            guard let authKey = authItem.key else {return}
            guard let authIssuer = authItem.account else {return}
            accountLabel.text = authItem.account
            passLabel.text = "otp"
            key = authKey
            issuer = authIssuer
            let token = testToken(name: issuer, issuer: issuer, secretString: key)
            passLabel.text = token?.currentPassword
            startTimer()
        }
    }
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let passLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль обновиться через 30 с."
        return label
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
        
        accountLabel.customize(fontSize: 24)
        addSubview(accountLabel)
        
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            accountLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            accountLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            accountLabel.heightAnchor.constraint(equalToConstant: 24)
            ])
        
        passLabel.customize(fontSize: 48)
        addSubview(passLabel)
        passLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            passLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            passLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            passLabel.heightAnchor.constraint(equalToConstant: 48)
         ])
        
        descriptionLabel.customize(fontSize: 16)
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
         ])

    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    // MARK: - Handlers
    
    @objc private func updateLabel (){
        countDown -= 1
       descriptionLabel.text = "Пароль обновиться через " + String(countDown) + "с."
        if countDown == 0 {
            countDown = 30
            let token = testToken(name: issuer, issuer: issuer, secretString: key)
            passLabel.text = token?.currentPassword
        }
    }

}

extension CustomCell{
    
    func testToken(name: String, issuer: String, secretString: String) -> Token? {

        guard let secretData = MF_Base32Codec.data(fromBase32String: secretString),
            !secretData.isEmpty else {
                print("Invalid secret")
                return nil
        }

        guard let generator = Generator(
            factor: .timer(period: 30),
            secret: secretData,
            algorithm: .sha1,
            digits: 6) else {
                print("Invalid generator parameters")
                return nil
        }

        let token = Token(name: name, issuer: issuer, generator: generator)

        return token
    }
}
