//
//  RowDetailViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import AVFoundation

protocol AddAccountViewControllerOutput: AnyObject {
    func didAdd()
}

class AddAccountViewController: UIViewController {

    // MARK: - Properties
    weak var output: AddAccountViewControllerOutput?

    let offsetX = 24.0
    let offsetY = 60.0
    let textFieldHeigth = 80.0
    var textFieldWidth: Double = 0.0

    private var issuerTextField = UITextFieldWithBottomBorder()
    private var keyTextField = UITextFieldWithBottomBorder()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Add account", comment: "")
        label.setAttributedText(fontSize: 20, text: text, aligment: .center, indent: 0.0)
        return label
    }()

    let createButton: RoundedButtonWithShadow = {
        let button = RoundedButtonWithShadow(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Create", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(handleCreateButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "addAccountScreenCreateButton"
        button.isAccessibilityElement = true
        return button
    }()

    let scanQRButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.lineBreakMode = .byWordWrapping
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
             .font: font,
             .foregroundColor: UIColor.label,
             .underlineStyle: NSUnderlineStyle.single.rawValue,
             .paragraphStyle: paragraphStyle
        ]
        let text = NSLocalizedString("Scan QR Code", comment: "")
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        button.addTarget(self, action: #selector(handleScanButton), for: .touchUpInside)
        button.setAttributedTitle(attributedText, for: .normal)
        button.accessibilityIdentifier = "addAccountScreenScanQrButton"
        button.isAccessibilityElement = true
        return button
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBackground
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        button.accessibilityIdentifier = "addAccountScreenCancel"
        button.isAccessibilityElement = true
        return button
    }()

    private let orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        return label
    }()

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: Functions

    private func setupControllers() {
        setupNavigationController()
        setupTextField(textField: issuerTextField, placeholderText: NSLocalizedString("Account", comment: ""), tag: 1)
        setupTextField(textField: keyTextField, placeholderText: NSLocalizedString("Secret key", comment: ""), tag: 2)
        let text = NSLocalizedString("or", comment: "")
        orLabel.setAttributedText(
            fontSize: 18,
            text: text,
            aligment: .center,
            indent: 0.0,
            color: UIColor(red: 0.702, green: 0.686, blue: 0.694, alpha: 1))
    }

    private func setupView() {

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .systemGray5
        setupLayouts()
        setupControllers()
    }

    private func setupLayouts() {

        view.backgroundColor = UIColor.systemBackground

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 79),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        textFieldWidth = Double(view.frame.width) - offsetX * 2

        issuerTextField = UITextFieldWithBottomBorder(frame:
            CGRect(x: offsetX,
                   y: offsetY*2,
                   width: textFieldWidth,
                   height: textFieldHeigth))
        view.addSubview(issuerTextField)
        issuerTextField.returnKeyType = UIReturnKeyType.next

        keyTextField = UITextFieldWithBottomBorder(frame:
            CGRect(x: offsetX,
                   y: textFieldHeigth + offsetY * 2,
                   width: textFieldWidth,
                   height: textFieldHeigth))
        view.addSubview(keyTextField)
        view.addSubview(scanQRButton)
        NSLayoutConstraint.activate([
            scanQRButton.topAnchor.constraint(equalTo: keyTextField.bottomAnchor, constant: 24),
            scanQRButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanQRButton.heightAnchor.constraint(equalToConstant: 100),
            scanQRButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        view.addSubview(orLabel)
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: scanQRButton.bottomAnchor, constant: 8),
            orLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 44),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.widthAnchor.constraint(equalToConstant: 320)
        ])
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 16),
            cancelButton.widthAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func setupTextField(textField: UITextField, placeholderText: String, tag: Int) {
        textField.backgroundColor = UIColor.systemBackground
        textField.textColor = UIColor.label
        textField.font = UIFont(name: "Lato-Light", size: 18)
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = true
        textField.placeholder = placeholderText
        textField.tag = tag
        textField.delegate = self
        textField.accessibilityIdentifier = placeholderText
        textField.isAccessibilityElement = true
    }

    private func showAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(
            title: NSLocalizedString(alertTitle, comment: ""),
            message: NSLocalizedString(alertMessage, comment: ""),
            preferredStyle: .alert)

        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)

    }

    private func showCameraPermissionAlert() {
        let alert = QRCameraScanner.cameraPermissionAlert()
        self.present(alert, animated: true, completion: nil)
    }

    private func setupCaptureSession() {
        let scanQrViewController = ScanQrViewController()
        scanQrViewController.output = self
        scanQrViewController.modalPresentationStyle = .fullScreen
        present(scanQrViewController, animated: true)
    }

    private func cheackCorrectAccount () -> Bool {
        if let issuer = issuerTextField.text {
            if issuer.isEmpty {
                return false
            }
        }

        if let key = keyTextField.text {

            if !TokenGenerator.shared.isValidSecretKey(secretKey: key) {
                return false
            }
        }
        return true
    }

    // MARK: - Handlers

    @objc private func handleCreateButtonTapped() {

        if !cheackCorrectAccount() {
            showAlert(alertTitle: NSLocalizedString("Wrong account",
                                                    comment: ""),
                      alertMessage: NSLocalizedString("Please enter correct account",
                                                      comment: ""))
        } else {
            try? AuthenticatorModel.shared.addOneItem(account: "",
                                                      issuer: issuerTextField.text,
                                                      key: keyTextField.text)
            output?.didAdd()
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func handleScanButton() {
        switch  AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {[weak self ] (granted) in
                    if granted {
                        DispatchQueue.main.async {
                            self?.setupCaptureSession()
                        }
                    }
                }
        default:
            showCameraPermissionAlert()
        }

    }

    @objc private func handleCancelButton() {
        dismiss(animated: true)
    }
}

extension AddAccountViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let bottomBorderTextField = textField as? UITextFieldWithBottomBorder else { return }
        bottomBorderTextField.updateBorder(color: .fucsiaColor)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let bottomBorderTextField = textField as? UITextFieldWithBottomBorder else { return }
        bottomBorderTextField.updateBorder(color: .graySOTPColor)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}

extension AddAccountViewController: ScanQrViewControllerOutput {

    func didFound(qrCodeString: String) throws {
        do {
            try AuthenticatorModel.shared.createItemFromURLString(urlString: qrCodeString)
            output?.didAdd()
            dismiss(animated: true)
        } catch {
            let title = NSLocalizedString("QR code has the wrong format", comment: "")
            let alert = UIAlertController.alertWithOk(title: title)
            present(alert, animated: true)
        }
    }

}
