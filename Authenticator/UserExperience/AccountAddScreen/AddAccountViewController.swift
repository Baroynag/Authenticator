//
//  RowDetailViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//


import UIKit
import AVFoundation

protocol AddAccountDelagate: AnyObject {
    func returnToMainScreeen()
}

class AddAccountViewController: UIViewController {
    
    // MARK: - Properties

    weak var addAccountDelagate: AddAccountDelagate? 
    weak var refreshTableDelegate: RefreshTableDelegate?
    
    private var isTimeBased = true

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
        label.setLabelAtributedText(fontSize: 20, text: text, aligment: .center, indent: 0.0)
        return label
    }()
    
    let createButton: RoundedButtonWithShadow = {
        let button = RoundedButtonWithShadow(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Create", comment: "") , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
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
        let attributedText = NSMutableAttributedString(string: NSLocalizedString("Scan QR Code", comment: "") , attributes: attributes)
        button.addTarget(self, action: #selector(handleScanButton), for: .touchUpInside)
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBackground
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
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
        print(#function)
        super.viewDidLoad()
        self.setupView()
    }
    
    // MARK: Functions
    
    private func setupControllers(){
        setupNavigationController()
        setupTextField(textField: issuerTextField, placeholderText: NSLocalizedString("Account", comment: "") , tag: 1)
        setupTextField(textField: keyTextField, placeholderText: NSLocalizedString("Secret key", comment: "") , tag: 2)
        orLabel.setLabelAtributedText(fontSize: 18, text: NSLocalizedString("or", comment: ""), aligment: .center, indent: 0.0, color: UIColor(red: 0.702, green: 0.686, blue: 0.694, alpha: 1))
    }
    
    private func setupView() {
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .systemGray5
        setupLayouts()
        setupControllers()
    }
    
    private func setupLayouts(){

        view.backgroundColor = UIColor.systemBackground
    
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 79),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        
        textFieldWidth = Double(view.frame.width) - offsetX * 2
        
        issuerTextField = UITextFieldWithBottomBorder(frame: CGRect(x: offsetX, y: offsetY*2, width: textFieldWidth, height: textFieldHeigth))
        view.addSubview(issuerTextField)
        issuerTextField.returnKeyType = UIReturnKeyType.next
        
        keyTextField = UITextFieldWithBottomBorder(frame: CGRect(x: offsetX, y: textFieldHeigth + offsetY * 2, width: textFieldWidth, height: textFieldHeigth))
        view.addSubview(keyTextField)
    
        view.addSubview(scanQRButton)
        NSLayoutConstraint.activate([
            scanQRButton.topAnchor.constraint(equalTo:  keyTextField.bottomAnchor, constant: 24),
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

    private func setupTextField(textField: UITextField, placeholderText: String, tag: Int)  {
        textField.backgroundColor = UIColor.systemBackground
        textField.textColor = UIColor.label
        textField.font = UIFont(name: "Lato-Light", size: 18)
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = true
        textField.placeholder = placeholderText
        textField.tag = tag
        textField.delegate = self
    }
    
    private func showAlert(alertTitle: String, alertMessage: String){
        print(alertTitle)
        let alert = UIAlertController(title: NSLocalizedString(alertTitle, comment: ""), message: NSLocalizedString(alertMessage, comment: ""), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "") , style: .default)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
       
    }

    private func showCameraPermissionAlert(){
        
        let alert = UIAlertController(title: NSLocalizedString("Camera access", comment: ""), message: NSLocalizedString("Please allow camera access for SOTP", comment: ""), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {_ in ()
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Handlers
    
    @objc private func handleSave() {

        if let issuer = issuerTextField.text{
            if issuer.isEmpty{
                showAlert(alertTitle: NSLocalizedString("Wrong account", comment: ""), alertMessage:  NSLocalizedString("Please enter correct account", comment: ""))
            }
        }
        if let key = keyTextField.text{
            if TokenGenerator.shared.isValidSecretKey(secretKey: key){
                
                AuthenticatorModel.shared.addOneItem(account: "", issuer: issuerTextField.text, key: keyTextField.text, timeBased: isTimeBased)
                
                addAccountDelagate?.returnToMainScreeen()
                refreshTableDelegate?.refresh()
                
                self.dismiss(animated: true, completion: nil)
                
            } else{
                 showAlert(alertTitle: NSLocalizedString("Wrong account", comment: ""), alertMessage:  NSLocalizedString("Please enter correct account", comment: ""))
            }
        }

    }
    
    @objc private func handleScanButton(){
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized{
            let scanQrViewController = ScanQrViewController()
            scanQrViewController.delegate = self
            scanQrViewController.modalPresentationStyle = .fullScreen
                self.present(scanQrViewController, animated: true)
        } else{
            self.showCameraPermissionAlert()
        }
    }
    
    @objc private func handleCancelButton(){
        self.dismiss(animated: true)
        
    }
}


extension AddAccountViewController: UITextFieldDelegate{
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let bottomBorderTextField = textField as? UITextFieldWithBottomBorder else { return }
        bottomBorderTextField.updateBorder(color: .fucsiaColor())
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let bottomBorderTextField = textField as? UITextFieldWithBottomBorder else { return }
        bottomBorderTextField.updateBorder(color: .graySOTPColor())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}
    
extension AddAccountViewController: AddItemDelegate{
    func createNewItem(account: String?, issuer: String?, key: String?, timeBased: Bool) {

        AuthenticatorModel.shared.addOneItem(account: account, issuer: issuer, key: key, timeBased: timeBased)

        
        if addAccountDelagate != nil{
            addAccountDelagate?.returnToMainScreeen()
        } else{
            refreshTableDelegate?.refresh()
            self.dismiss(animated: true, completion: nil)
        }
    }

}
