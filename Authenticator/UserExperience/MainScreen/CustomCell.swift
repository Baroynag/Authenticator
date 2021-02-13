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
    private var issuer = ""
    private var account = ""
    private var copyCountDown = 0
    private var isCopyCountPressed = false
    private var isEditMode = false
    public let copiedTime = 2

    public var passLabelText = ""

    public var authItem: SOTPPersistentToken? {
        didSet {
            guard let sotpToken = authItem else {return}
            let authIssuer = sotpToken.token?.issuer ?? ""
            let account = sotpToken.token?.name ?? ""

            issuer = authIssuer

            issuerLabel.setAttributedText(text: authIssuer,
                                          fontSize: 18,
                                          aligment: .center,
                                          indent: 0.0,
                                          color: UIColor.label,
                                          fontWeight: .medium)

            accountLabel.setAttributedText(text: account,
                                           fontSize: 16,
                                           aligment: .center,
                                           indent: 0.0,
                                           color: .fucsiaColor,
                                           fontWeight: .light)

            if let keyText = sotpToken.token?.currentPassword {
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

    private func setupView() {
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

    private func startCopy() {
        copyCountDown = copiedTime
        isCopyCountPressed = true
        setupCopiedLabelText(text: NSLocalizedString("Copied", comment: ""))
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    private func endCopy() {
        copyCountDown = 0
        isCopyCountPressed = false
        setupPassLabelText(text: passLabelText)
    }

    private func setupPassLabelText (text: String) {
        var newText = text
        if isEditMode {
            newText = "------"
        }
        let font = UIFont.systemFont(ofSize: 50, weight: .thin)
        passLabel.textAlignment = .center
        passLabel.attributedText = NSMutableAttributedString(string: newText, attributes: [.kern: 5.75, .font: font])
    }

    private func setupCopiedLabelText (text: String) {
        let font = UIFont.systemFont(ofSize: 32, weight: .thin)
        passLabel.textAlignment = .center
        passLabel.attributedText = NSMutableAttributedString(string: text, attributes: [.kern: 5.75, .font: font])
    }

    public func copyToClipBoard() {

        startCopy()
        let pasteboard = UIPasteboard.general
        pasteboard.string = passLabelText

    }

    public func startEditing() {

        isEditMode = true
        descriptionLabel.isHidden = true
        copyButton.isHidden = true
        setupPassLabelText(text: "------")
    }

    public func stopEditing() {

        isEditMode = false
        updateTimerInfoLabel()
        resetToken()
        descriptionLabel.isHidden = false
        copyButton.isHidden = false
    }

    private func resetToken() {

        if let text = authItem?.token?.currentPassword {
            setupPassLabelText(text: text)
            passLabelText = text
        }

    }

    // MARK: - Handlers

    @objc public func updateTimerInfoLabel () {

        if isEditMode {return}

        let countDown = Int(NSDate().timeIntervalSince1970) % 30
        var timeLabel = String(30 - countDown)

        if countDown == 0 {
            timeLabel = "1"
        }
        descriptionLabel.text = NSLocalizedString("Refresh in ", comment: "") + timeLabel + " " +
            NSLocalizedString("s.", comment: "")

        if isCopyCountPressed {
            copyCountDown -= 1
            if copyCountDown == 0 {
                endCopy()
            }
        }

        if countDown == 0 {
            resetToken()
        }

    }

    @objc private func handleCopyButton() {
        copyToClipBoard()
    }

}
