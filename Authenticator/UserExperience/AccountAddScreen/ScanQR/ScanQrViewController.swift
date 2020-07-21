//
//  ScanQrViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 25.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//


import UIKit
import AVFoundation
import UIKit

class ScanQrViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: AddItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("viewDidLoad")
        
        view.backgroundColor = UIColor.black
        
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print ("1")
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
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

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print ("viewWillAppear")
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print ("viewWillDisappear")

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        print ("metadataOutput")
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            found(urlString: stringValue)
            
        } else { dismiss(animated: true)}
        
    }

    func found(urlString: String) {

        /*otpauth://totp/VK:id132504071?secret=25PXK6NNGXI4OH7L&issuer=VK*/
        
        if let url = URLComponents(string: urlString) {
            
            let account   = url.path.replacingOccurrences(of: "/", with: "")
            let issuer    = getQueryStringParameter(url: url, param: "issuer")
            let key       = getQueryStringParameter(url: url, param: "secret")
            delegate?.createNewItem(account: account, issuer: issuer, key: key, timeBased: true)
            
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
}

