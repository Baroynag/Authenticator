//
//  GreetingViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 29.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

protocol GreetingViewControllerOutput: class {
    func didLoadBackup()
    func didAdd(account: String?, issuer: String?, key: String?)
}

final class GreetingViewController: UIViewController {

    // MARK: - Properties
    weak var output: GreetingViewControllerOutput?

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
        label.setAttributedText(fontSize: 24, text: text, aligment: .center, indent: 0.0)
        return label
    }()

    private let sotpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("SOTP", comment: "")
        label.setAttributedText(fontSize: 32, text: text, aligment: .center, indent: 0.0, color: .fucsiaColor)
        return label
    }()

    private let setupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Setup one time password", comment: "")
        label.setAttributedText(fontSize: 20, text: text, aligment: .center, indent: 0.0)
        return label
    }()

    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.sotpShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Create", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        return button
    }()

    let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.sotpShadow()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(NSLocalizedString("Load from file", comment: ""), for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            button.addTarget(self, action: #selector(handleLoad), for: .touchUpInside)
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

    // MARK: - Functions
    private func setupLayout() {

        loadButton.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor.systemBackground

        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 145),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 199)
         ])

        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor, constant: 19),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.addSubview(sotpLabel)
        NSLayoutConstraint.activate([
            sotpLabel.topAnchor.constraint(lessThanOrEqualTo: greetingLabel.bottomAnchor, constant: 14),
            sotpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.addSubview(setupLabel)
        NSLayoutConstraint.activate([
            setupLabel.topAnchor.constraint(lessThanOrEqualTo: sotpLabel.bottomAnchor, constant: 8),
            setupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setupLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            setupLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(lessThanOrEqualTo: setupLabel.bottomAnchor, constant: 30),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.widthAnchor.constraint(equalToConstant: 320)
        ])

        view.addSubview(loadButton)
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(lessThanOrEqualTo: createButton.bottomAnchor, constant: 22),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.heightAnchor.constraint(equalToConstant: 50),
            loadButton.widthAnchor.constraint(equalToConstant: 320)
        ])
    }
}

extension GreetingViewController: AddAccountViewControllerOutput {
    func didAdd(account: String?, issuer: String?, key: String?) {
        output?.didAdd(account: account, issuer: issuer, key: key)
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
                            self.output?.didLoadBackup()
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
