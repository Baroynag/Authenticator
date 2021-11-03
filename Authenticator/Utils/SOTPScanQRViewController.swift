//
//  SOTPScanQRViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 26.09.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI

protocol SOTPScanQRViewControllerOutput: AnyObject {
    func didFound(success: Bool)
}

class SOTPScanQRViewController: UIViewController {

    weak var scannQROutput: SOTPScanQRViewControllerOutput?

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
        var success: Bool = true
        do {
            try AuthenticatorModel.shared.loadFromScannedGoogleAuthenticatorImage(image: image)
        } catch {
            success = false
            let alert = failedAlert()
            present(alert, animated: true)
        }

        scannQROutput?.didFound(success: success)

        if scannQROutput is AuthenticatorViewController {
            present(loadedAlert(), animated: true)
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

extension SOTPScanQRViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
extension SOTPScanQRViewController: PHPickerViewControllerDelegate {
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

extension SOTPScanQRViewController: ScanQrViewControllerOutput {
    func didFound(qrCodeString: String) {
        var success: Bool = true
        do {
            try AuthenticatorModel.shared.importFromGoogleAuthenticatorURL(urlString: qrCodeString)
        } catch {
            success = false
            present(failedAlert(), animated: true)
        }
        scannQROutput?.didFound(success: success)
    }
}
