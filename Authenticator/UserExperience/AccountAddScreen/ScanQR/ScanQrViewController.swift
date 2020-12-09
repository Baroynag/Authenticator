//
//  ScanQrViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 25.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQrViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: AddItemDelegate?

    let cancelButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBackground
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print(NSLocalizedString("Capture error \(error.localizedDescription)", comment: ""))
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        view.backgroundColor = UIColor.black
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 16),
            cancelButton.widthAnchor.constraint(equalToConstant: 16)
        ])

        captureSession.startRunning()
    }

    func failed() {
        let title = "Scanning not supported"
        let message = "Your device does not support scanning a code from an item. Please use a device with a camera."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }

    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.dismiss(animated: true, completion: nil)
            found(urlString: stringValue)

        } else { self.dismiss(animated: true, completion: nil)}

    }

    func found(urlString: String) {

        if let url = URLComponents(string: urlString) {

            let account   = url.path.replacingOccurrences(of: "/", with: "")
            let issuer    = getQueryStringParameter(url: url, param: "issuer")
            let key       = getQueryStringParameter(url: url, param: "secret")
            delegate?.createNewItem(account: account, issuer: issuer, key: key)

        }
   }

    func getQueryStringParameter(url: URLComponents, param: String) -> String? {
      return url.queryItems?.first(where: { $0.name == param })?.value
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @objc private func handleCancelButton() {
        self.dismiss(animated: true)
    }
}
