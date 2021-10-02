//
//  QRCameraScanner.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 22.09.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum ImportAlertOptionsLocalizedStrings {
    static let camera: String = NSLocalizedString("Camera", comment: "")
    static let photoLibrary: String = NSLocalizedString("Photo library", comment: "")
    static let dismiss: String = NSLocalizedString("Dismiss", comment: "")
}
enum ImportAlertOptions {
    case camera
    case photoLibrary
    case dismiss
}

class QRCameraScanner {

    class public func requestCameraAutorizationStatus (
        completion: @escaping (_ status: AVAuthorizationStatus) -> Void) {

        let currentStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch  currentStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {(_) in
                completion(AVCaptureDevice.authorizationStatus(for: .video))
                }
        default:
            completion(currentStatus)
        }
    }

    class public func cameraPermissionAlert() -> UIAlertController {

        let title = NSLocalizedString("Camera access", comment: "")
        let message = NSLocalizedString("Please allow camera access for SOTP",
                                        comment: "")
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .cancel,
                                      handler: nil))
        return alert
    }

    class public func scanFromAlert(completion: @escaping (_ option: ImportAlertOptions) -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: NSLocalizedString("Scan QR code from", comment: ""),
            message: "",
            preferredStyle: .actionSheet)

        alert.addAction(
            UIAlertAction(title: ImportAlertOptionsLocalizedStrings.camera,
                          style: .default,
                          handler: {_ in
                            completion(ImportAlertOptions.camera)
                          })
        )
        alert.addAction(
            UIAlertAction(title: ImportAlertOptionsLocalizedStrings.photoLibrary,
                          style: .default,
                          handler: {_ in
                            completion(ImportAlertOptions.photoLibrary)
                          })
        )
        alert.addAction(
            UIAlertAction(title: ImportAlertOptionsLocalizedStrings.dismiss,
                          style: .cancel,
                          handler: { (_) in
                            completion(ImportAlertOptions.dismiss)
                          })
        )
        return alert
    }

}
