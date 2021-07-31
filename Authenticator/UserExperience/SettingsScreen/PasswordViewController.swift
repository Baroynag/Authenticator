//
//  PasswordViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 16.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    // MARK: - Properties

    private let offsetX: CGFloat = 24.0
    private let offsetY: CGFloat = 64.0
    private let textFieldHeigth: CGFloat = 80.0
    private var textFieldWidth: CGFloat = 0.0

    private var passwordTextField = UITextFieldWithBottomBorder()
    private var confirmPasswordTextField = UITextFieldWithBottomBorder()

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .fucsiaColor
        // review: в константы
        button.setTitle(NSLocalizedString("Ok", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        // review: в константы
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.accessibilityIdentifier = "passwordConfirmButton"
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBackground
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.accessibilityIdentifier = "passwordcancelButton"
        return button
    }()

    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupView()
    }

    // MARK: - Functions
    private func setupView() {
        navigationController?.navigationBar.isHidden = false

        view.backgroundColor = UIColor.systemBackground

        textFieldWidth = view.frame.width - offsetX * 2

        passwordTextField = UITextFieldWithBottomBorder(
            frame: CGRect(x: offsetX,
                          y: offsetY * 2,
                          width: textFieldWidth,
                          height: textFieldHeigth))
        view.addSubview(passwordTextField)
        passwordTextField.returnKeyType = UIReturnKeyType.next

        confirmPasswordTextField = UITextFieldWithBottomBorder(
            frame: CGRect(x: offsetX,
                          y: textFieldHeigth + offsetY * 2,
                          width: textFieldWidth,
                          height: textFieldHeigth))
        view.addSubview(confirmPasswordTextField)

        // review: в константы
        setupTextField(textField: passwordTextField,
                       placeholderText: NSLocalizedString("Password",
                                                          comment: ""), tag: 1)

        // review: в константы
        setupTextField(
            textField: confirmPasswordTextField,
            placeholderText: NSLocalizedString("Confirm password", comment: ""), tag: 2)

        view.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(
                equalTo: confirmPasswordTextField.bottomAnchor,
                constant: 48),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 80),
            confirmButton.widthAnchor.constraint(equalToConstant: 80)
        ])

        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16),
            cancelButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 16),
            cancelButton.widthAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func setupTextField(textField: UITextField, placeholderText: String, tag: Int) {
        textField.backgroundColor = UIColor.systemBackground
        textField.textColor = UIColor.label
        // review: в константы
        textField.font = UIFont(name: "Lato-Light", size: 18)
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = true
        textField.placeholder = placeholderText
        textField.tag = tag
        textField.delegate = self
        textField.isSecureTextEntry = true
    }

    private func showErrorAlert(errorText: String) {
        let alert = UIAlertController(title: "", message: errorText, preferredStyle: .alert)
        // review: в константы
        let action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func validatePassword(completion: @escaping (String?) -> Void ) {
        do {
            let isValidPassword = try PasswordError.cheackPassword(
                passOne: passwordTextField.text,
                passTwo: confirmPasswordTextField.text)

            if isValidPassword {
                completion(passwordTextField.text)
            }
        } catch {
            showErrorAlert(errorText: error.localizedDescription)
        }
    }

    // MARK: - Handlers
    @objc private func handleConfirmButton() {
        validatePassword { [weak self] pass in
            if let pass = pass {
                self?.saveBackupToFile(password: pass)
            }
        }
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    private func saveBackupToFile(password: String) {
        // TODO: add error message
        guard let backupFile = Backup.getEncriptedData(password: password) else {return}

        let temporaryFolder = FileManager.default.temporaryDirectory
        // review: в константы, может даже на глобальный уровень
        let temporaryFilePath = temporaryFolder.appendingPathComponent("sotpbackup.sotp")

        do {
            try backupFile.write(to: temporaryFilePath, atomically: true, encoding: .utf8)
            let activityViewController = UIActivityViewController(
                activityItems: [temporaryFilePath],
                applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view
            present(activityViewController, animated: true)

            activityViewController.completionWithItemsHandler = {(_: UIActivity.ActivityType?, completed: Bool, _: [Any]?, error: Error?) in
                if completed {
                    self.dismiss(animated: true, completion: nil)
                }

                if let error = error {
                    print("error while sharing: \(error.localizedDescription)")
                }
            }

        } catch {
            print(error.localizedDescription)
        }
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let bottomBorderTextField = textField as? UITextFieldWithBottomBorder else { return }
        bottomBorderTextField.updateBorder(color: .fucsiaColor)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let bottomBorderTextField = textField as? UITextFieldWithBottomBorder else { return }
        bottomBorderTextField.updateBorder(color: .graySOTPColor)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var result = false
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            result = true
        }

        return result
    }
}
