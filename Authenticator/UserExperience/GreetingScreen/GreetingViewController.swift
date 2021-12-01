//
//  GreetingViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 29.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import PhotosUI

protocol GreetingViewControllerOutput: AnyObject {
    func didAddRecords(success: Bool)
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
    func didAdd() {
        output?.didAddRecords(success: true)
    }
}

extension GreetingViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let fileUrl = urls.first {
            dismiss(animated: true) {[weak self ] in
                let promtForPassword = UIAlertController.promptForPassword { (pass) in
                    do {
                        try Backup.getFileContent(fileURL: fileUrl, password: pass)
                        self?.output?.didAddRecords(success: true)
                        let alert = UIAlertController.alertWithLocalizedTitle(title: "Data loaded")
                        self?.present(alert, animated: true)
                    } catch {
                        let alert = UIAlertController.alertWithLocalizedTitle(title: "Unable to upload file")
                        self?.present(alert, animated: true)
                    }
                }
                self?.present(promtForPassword, animated: true)
            }
        }
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension GreetingViewController {

    public func loadFromGoogleAuthenticator() {
        let alert = QRCameraScanner.scanFromAlert { [weak self] option in
            switch option {
            case .camera:
                self?.scanWithCamera()
            case .photoLibrary:
                self?.showImagePicker()
            default: break
            }
        }
        self.present(alert, animated: true)
    }

    private func importFromGoogleAuthenticatorQRImage(image: UIImage) {
        do {
            try AuthenticatorModel.shared.loadFromScannedGoogleAuthenticatorImage(image: image)
            output?.didAddRecords(success: true)
        } catch {
            let alert = failedAlert()
            present(alert, animated: true)
        }

    }

    private func showImagePickerController() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }

    @available(iOS 14, *)
    private func showPhpImagePicker() {
        DispatchQueue.main.async { [weak self] in
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            let filter = PHPickerFilter.any(of: [.images])
            configuration.filter = filter
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self?.present(picker, animated: true)
        }
    }

    private func showImagePicker() {
        if #available(iOS 14, *) {
            showPhpImagePicker()
        } else {
            showImagePickerController()
        }
    }

    private func scanWithCamera() {
        QRCameraScanner.requestCameraAutorizationStatus { [weak self] currentStatus in
            DispatchQueue.main.async {
                if currentStatus == .authorized {
                    self?.setupCaptureSession()
                } else {
                    let alert = QRCameraScanner.cameraPermissionAlert()
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    private func setupCaptureSession() {
        let scanQrViewController = ScanQrViewController()
        scanQrViewController.output = self
        scanQrViewController.modalPresentationStyle = .fullScreen
        present(scanQrViewController, animated: true)
    }

}

extension GreetingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let image = info[.editedImage] else {return}

        if let selectedImage = image as? UIImage {
            self.importFromGoogleAuthenticatorQRImage(image: selectedImage)
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func loadedAlert() -> UIAlertController {
        let title = NSLocalizedString("Data loaded", comment: "")
        return UIAlertController.alertWithOk(title: title)
    }

    func failedAlert() -> UIAlertController {
        let title = NSLocalizedString("QR code has the wrong format", comment: "")
        return UIAlertController.alertWithOk(title: title)
    }
}

@available(iOS 14, *)
extension GreetingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    if let selectedImage = image as? UIImage {
                        self?.importFromGoogleAuthenticatorQRImage(image: selectedImage)
                    }
                }
            }
        }
    }

}

extension GreetingViewController: ScanQrViewControllerOutput {

    func didFound(qrCodeString: String) {
        do {
            try AuthenticatorModel.shared.importFromGoogleAuthenticatorURL(urlString: qrCodeString)
            output?.didAddRecords(success: true)
        } catch {
            present(failedAlert(), animated: true)
        }
    }
}
