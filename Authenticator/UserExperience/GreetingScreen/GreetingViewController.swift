//
//  GreetingViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 29.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import PhotosUI

final class GreetingViewController: SOTPScanQRViewController {

    // MARK: - Properties
    private let imageView: UIImageView = {
        let image = UIImage(named: "greeting")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Welcome to", comment: "")
        label.setAttributedText(fontSize: 20, text: text, aligment: .center, indent: 0.0)
        return label
    }()

    private let sotpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("SOTP", comment: "")
        label.setAttributedText(fontSize: 20, text: text, aligment: .center, indent: 0.0, color: .fucsiaColor)
        return label
    }()

    private let setupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Setup one time password", comment: "")
        label.setAttributedText(fontSize: 17, text: text, aligment: .center, indent: 0.0)
        return label
    }()

    let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Create", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        button.accessibilityIdentifier = "greetingScreenCreateButton"
        button.backgroundColor = UIColor.fucsiaColor
        button.layer.cornerRadius = 25
        return button
    }()

    lazy var loadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Load from file", comment: ""), for: .normal)
        let textColor = getTextColor()
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(handleLoad), for: .touchUpInside)
        button.accessibilityIdentifier = "greetingScreenLoadButton"
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.graySOTPColor.cgColor
        button.layer.cornerRadius = 25
        return button
    }()

    lazy var loadButtonFromGoogleAuthenticator: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Load from Google", comment: ""), for: .normal)
        let textColor = getTextColor()
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(handleLoadFromGoogleAuthenticator), for: .touchUpInside)
        button.accessibilityIdentifier = "loadFromGoogleAuthenticator"
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.graySOTPColor.cgColor
        button.layer.cornerRadius = 25
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "google_icon"), for: .normal)
        return button
    }()
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupLayout()
    }

    // MARK: - Handlers
    @objc private func handleCreate() {
        let addAccountViewController = AddAccountViewController()
        addAccountViewController.output = self
        present(addAccountViewController, animated: true, completion: nil)
    }

    @objc private func handleLoad() {
        chooseDocument(vcWithDocumentPicker: self)
    }

    @objc private func handleLoadFromGoogleAuthenticator() {
        loadFromGoogleAuthenticator()
    }

    // MARK: - Functions
    private func setupLayout() {

        loadButton.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor.systemBackground

        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 151),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 212)
        ])

        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor, constant: 19),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        view.addSubview(sotpLabel)
        NSLayoutConstraint.activate([
            sotpLabel.topAnchor.constraint(lessThanOrEqualTo: greetingLabel.bottomAnchor, constant: 14),
            sotpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sotpLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        view.addSubview(setupLabel)
        NSLayoutConstraint.activate([
            setupLabel.topAnchor.constraint(lessThanOrEqualTo: sotpLabel.bottomAnchor, constant: 8),
            setupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setupLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        let stackView = setupStackViewWithButtons()

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(lessThanOrEqualTo: setupLabel.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func setupStackViewWithButtons() -> UIStackView {
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.widthAnchor.constraint(equalToConstant: 287)
        ])

        NSLayoutConstraint.activate([
            loadButton.heightAnchor.constraint(equalToConstant: 50),
            loadButton.widthAnchor.constraint(equalToConstant: 287)
        ])

        NSLayoutConstraint.activate([
            loadButtonFromGoogleAuthenticator.heightAnchor.constraint(equalToConstant: 50),
            loadButtonFromGoogleAuthenticator.widthAnchor.constraint(equalToConstant: 287)
        ])

        let stackView = UIStackView(arrangedSubviews: [createButton,
                                                       loadButton,
                                                       loadButtonFromGoogleAuthenticator])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 22

        return stackView
    }

    private func getTextColor() -> UIColor {
        var color = UIColor.white
        if traitCollection.userInterfaceStyle == .light {
            color = UIColor.graySOTPColorForTitle
        }
        return color
    }
}

extension GreetingViewController: AddAccountViewControllerOutput {
    func reloadMainTableView() {
        scannQROutput?.actionAfterQRScanning(isError: false)
    }
}

extension GreetingViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let title = NSLocalizedString("Wrong password", comment: "")
        if let fileURL = urls.first {
            dismiss(animated: true) { [weak self] in
                guard let self = self else {
                    return
                }

                let promtForPassword = UIAlertController.promptForPassword { pass in
                    if let pass = pass {
                        if Backup.getFileContent(fileURL: fileURL, password: pass) {
                            self.scannQROutput?.actionAfterQRScanning(isError: false)
                        } else {
                            let alert = UIAlertController.alertWithOk(title: title)
                            self.present(alert, animated: true)
                        }
                    }
                }
                self.present(promtForPassword, animated: true)
            }
        }
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
