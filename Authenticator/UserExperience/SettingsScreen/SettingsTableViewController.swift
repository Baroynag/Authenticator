//
//  SettingsTableViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import PhotosUI

protocol SettingsTableViewControllerOutput: AnyObject {
    func didAddRecords()
}

class SettingsTableViewController: UIViewController {

    let cellId = "settingsCellId"
    let cellWithButtonId = "settingsCellWithButtonId"
    var tableView = UITableView()
    weak var output: SettingsTableViewControllerOutput?

    let settingsList = [
        NSLocalizedString("Support this project", comment: ""),
        NSLocalizedString("Transfer data", comment: ""),
        NSLocalizedString("Load from file", comment: ""),
        NSLocalizedString("Load from Google Authenticator", comment: ""),
        NSLocalizedString("About SOTP", comment: "")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        setupView()
    }

    private func createTable() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SettingsTableViewCellWithButton.self, forCellReuseIdentifier: cellWithButtonId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    private func setupView() {
        setupNavigationController()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        // review: В контсанты
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        view.backgroundColor = UIColor.systemBackground
    }
}

extension SettingsTableViewController: SettingsTableViewCellWithButtonOutput {
    func didTapPurchase() {
        let purchaseViewController = PurchaseViewController()
        present(purchaseViewController, animated: true, completion: nil)
    }
}

extension SettingsTableViewController: UIDocumentPickerDelegate {

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        if let fileUrl = urls.first {
            dismiss(animated: true) {[weak self ] in
                let promtForPassword = UIAlertController.promptForPassword { (pass) in
                    do {
                        try Backup.getFileContent(fileURL: fileUrl, password: pass)
                        self?.output?.didAddRecords()
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

// MARK: - UITableViewDataSource
extension SettingsTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numbersOfRows = 0
        if section == 0 {
            numbersOfRows = 1
        } else {
            numbersOfRows = settingsList.count - 1
        }

        return numbersOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellWithButtonId,
                for: indexPath)
            if let cellWithButton = cell as? SettingsTableViewCellWithButton {
                cellWithButton.title = settingsList[indexPath.row]
                cellWithButton.output = self
                cellWithButton.purchaseButton.tag = indexPath.row
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellId, for: indexPath)

            if let customCell = cell as? SettingsTableViewCell {
                customCell.accessoryType = .disclosureIndicator
                customCell.title = settingsList[indexPath.row + 1]
            }
            return cell

        }

    }
}

extension SettingsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 1 {
            if traitCollection.userInterfaceStyle == .light {
                view.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
            } else {
                view.backgroundColor =   UIColor(red: 0.158, green: 0.158, blue: 0.158, alpha: 1)
            }
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            return
        }

        if indexPath.row == 0 {
            let passwordViewController = PasswordViewController()
            present(passwordViewController, animated: true)

        } else if indexPath.row == 1 {
            chooseDocument(vcWithDocumentPicker: self)
        } else if indexPath.row == 2 {
            loadFromGoogleAuthenticator()
        } else if  indexPath.row == 3 {
            let aboutVc = AboutViewController()
            present(aboutVc, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsTableViewController {

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
            output?.didAddRecords()
            present(loadedAlert(), animated: true)
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

extension SettingsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
extension SettingsTableViewController: PHPickerViewControllerDelegate {
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

extension SettingsTableViewController: ScanQrViewControllerOutput {

    func didFound(qrCodeString: String) {
        do {
            try AuthenticatorModel.shared.importFromGoogleAuthenticatorURL(urlString: qrCodeString)
            output?.didAddRecords()
            present(loadedAlert(), animated: true)
        } catch {
            present(failedAlert(), animated: true)
        }
    }
}
