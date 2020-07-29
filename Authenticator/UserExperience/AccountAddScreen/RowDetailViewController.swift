//
//  RowDetailViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//


import UIKit


class RowDetailViewController: UIViewController {
    
    // MARK: - Properties

    weak var delegate: AddItemDelegate?
    
    private var isTimeBased = true

    let offsetX = 24.0
    let offsetY = 64.0
    let textFieldHeigth = 80.0
    var textFieldWidth: Double = 0.0
    

    private var issuerTextField = UITextFieldWithBottomBorder()
    private var keyTextField = UITextFieldWithBottomBorder()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.setTitle(NSLocalizedString("Create", comment: "") , for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let scanQRButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.lineBreakMode = .byWordWrapping
        let font = UIFont(name: "Lato-Light", size: 18)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
             .font: font!,
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
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cancelButton"), for: .normal)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        return button
    }()
    
    private let switchControl: UISwitch = {
        let swtch = UISwitch(frame: CGRect(x: 0, y:  5, width: 50, height: 50))
        swtch.isOn = true
        swtch.onTintColor = .fucsiaColor()
        swtch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return swtch
    }()
    
    private let switchLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let switchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        return label
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
    
    private func setupControllers(){
        setupNavigationController()
        navigationItem.title = NSLocalizedString("Add new account", comment: "")
        setupTextField(textField: issuerTextField, placeholderText: NSLocalizedString("Account", comment: "") , tag: 1)
        setupTextField(textField: keyTextField, placeholderText: NSLocalizedString("Secret key", comment: "") , tag: 2)
        switchLabel.setLabelAtributedText(fontSize: 18, text: NSLocalizedString("Time-based", comment: ""), aligment: .center, indent: 0.0)
        orLabel.setLabelAtributedText(fontSize: 18, text: NSLocalizedString("or", comment: ""), aligment: .center, indent: 0.0)
    }
    
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        setupNavigationController()
        view.backgroundColor = .systemGray5
        setupLayouts()
        setupControllers()
    }
    
    private func setupLayouts(){

        view.backgroundColor = UIColor.systemBackground
        
        textFieldWidth = Double(view.frame.width) - offsetX * 2
        
        issuerTextField = UITextFieldWithBottomBorder(frame: CGRect(x: offsetX, y: offsetY*2, width: textFieldWidth, height: textFieldHeigth))
        view.addSubview(issuerTextField)
        issuerTextField.returnKeyType = UIReturnKeyType.next
        
        keyTextField = UITextFieldWithBottomBorder(frame: CGRect(x: offsetX, y: textFieldHeigth + offsetY * 2, width: textFieldWidth, height: textFieldHeigth))
        view.addSubview(keyTextField)
        
        view.addSubview(switchLabel)
        NSLayoutConstraint.activate([
            switchLabel.topAnchor.constraint(equalTo: keyTextField.bottomAnchor, constant: 24),
            switchLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            switchLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -120),
            switchLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(switchLayerView)
        NSLayoutConstraint.activate([
            switchLayerView.topAnchor.constraint(equalTo: keyTextField.bottomAnchor,constant: 24),
            switchLayerView.leadingAnchor.constraint(equalTo: switchLabel.trailingAnchor),
            switchLayerView.heightAnchor.constraint(equalToConstant: 40),
            switchLayerView.widthAnchor.constraint(equalToConstant: 50)
        ])
        switchLayerView.addSubview(switchControl)
        
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: switchLayerView.bottomAnchor, constant: 24),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        view.addSubview(orLabel)
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 24),
            orLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        view.addSubview(scanQRButton)
        NSLayoutConstraint.activate([
            scanQRButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 16),
            scanQRButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanQRButton.heightAnchor.constraint(equalToConstant: 100),
            scanQRButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: scanQRButton.bottomAnchor, constant: 8),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 80),
            cancelButton.widthAnchor.constraint(equalToConstant: 80)
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

    
    // MARK: - Handlers
    
    @objc private func handleSave() {
        delegate?.createNewItem(account: "", issuer: issuerTextField.text, key: keyTextField.text, timeBased: isTimeBased)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func switchValueChanged(_ sender:UISwitch!){
        isTimeBased = sender.isOn
    }
    
    @objc private func handleScanButton(){
        
        let scanQrViewController = ScanQrViewController()
        scanQrViewController.delegate = self
        scanQrViewController.modalPresentationStyle = .fullScreen

       navigationController?.pushViewController(scanQrViewController, animated: true)
    }
    
    @objc private func handleCancelButton(){
        navigationController?.popViewController(animated: true)
    }
 
}


extension RowDetailViewController: UITextFieldDelegate{
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let bottomBorderTextField = textField as? UITextFieldWithBottomBorder else { return }
        bottomBorderTextField.updateBorder(color: .fucsiaColor())
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let bottomBorderTextField = textField as? UITextFieldWithBottomBorder else { return }
        bottomBorderTextField.updateBorder(color: .systemGray2)
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
    
extension RowDetailViewController: AddItemDelegate{
    func createNewItem(account: String?, issuer: String?, key: String?, timeBased: Bool) {
        self.delegate?.createNewItem(account: account, issuer: issuer, key: key, timeBased: timeBased)
    }
 
}
