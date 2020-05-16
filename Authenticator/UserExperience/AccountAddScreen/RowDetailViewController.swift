//
//  RowDetailViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//


import UIKit


class RowDetailViewController: UIViewController /*, UITextFieldDelegate*/ {
    
    // MARK: - Properties

    weak var delegate: VC2Delegate?
    
    private var isTimeBased = true

    let offsetX = 24.0
    let offsetY = 64.0
    let textFieldHeigth = 80.0
    var textFieldWidth: Double = 0.0
    
    private var accountTextField = UITextField()
    private var keyTextField = UITextField()
    
    let accountTextFieldBorder = CALayer()
    let keyTextFieldBorder = CALayer()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.setTitle("Создать", for: .normal)
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
        let attributedText = NSMutableAttributedString(string: "Сканировать\nQR код", attributes: attributes)
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
        return label
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public var editedText: String? {
        didSet{
            guard let editedText = editedText else {return}
            accountTextField.text = editedText
        }
    }
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Functions
    
    private func setupControllers(){
        setupNavigationController()
        navigationItem.title = "Добавить аккаунт"
        setupTextField(textField: accountTextField, placeholderText: "Аккаунт", tag: 1)
        setupTextField(textField: keyTextField, placeholderText: "Секретный ключ", tag: 2)
        switchLabel.customize(fontSize: 18)
        switchLabel.text = "Time-based"
        
        orLabel.customize(fontSize: 18)
        orLabel.text = "или"
    }
    
    private func setupView() {
        setupNavigationController()
        view.backgroundColor = .systemGray5
        setupLayouts()
        setupControllers()
    }
    
    private func setupLayouts(){
        view.backgroundColor = UIColor.systemBackground
        
        textFieldWidth = Double(view.frame.width) - offsetX * 2
        
        accountTextField = UITextField(frame: CGRect(x: offsetX, y: offsetY*2, width: textFieldWidth, height: textFieldHeigth))
        view.addSubview(accountTextField)
        createBorder(textField: accountTextField, color: UIColor.systemGray2, borderWidth: 2.0, border: accountTextFieldBorder)
        accountTextField.layer.addSublayer(accountTextFieldBorder)
        
        keyTextField = UITextField(frame: CGRect(x: offsetX, y: textFieldHeigth + offsetY * 2, width: textFieldWidth, height: textFieldHeigth))
        view.addSubview(keyTextField)
        createBorder(textField: keyTextField, color: UIColor.systemGray2, borderWidth: 2.0, border: keyTextFieldBorder)
        keyTextField.layer.addSublayer(keyTextFieldBorder)
      
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
            scanQRButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 24),
            scanQRButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanQRButton.heightAnchor.constraint(equalToConstant: 100),
            scanQRButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: scanQRButton.bottomAnchor, constant: 24),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
    
    func createBorder(textField: UITextField, color: UIColor, borderWidth: CGFloat, border: CALayer) -> Void {
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0.0, y: textField.frame.size.height - borderWidth, width: textField.frame.size.width, height: borderWidth);
    }
    
    func updateBorder(color: UIColor, border: CALayer) -> Void {
        border.backgroundColor = color.cgColor
    }
    
    // MARK: - Handlers
    
    @objc private func handleSave(){
        var authItem = Authenticator()
        authItem.account = accountTextField.text
        authItem.key = keyTextField.text
        authItem.timeBased = isTimeBased
        delegate?.titleDidChange(newAuthItem: authItem)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func switchValueChanged(_ sender:UISwitch!){
        isTimeBased = sender.isOn
    }
    
    @objc private func handleScanButton(){
        
        let scanQrViewController = ScanQrViewController()
//        scanQrViewController.delegate = self
        scanQrViewController.modalPresentationStyle = .fullScreen
        self.present(scanQrViewController, animated: true, completion: nil)
    }
    
    @objc private func handleCancelButton(){
        print ("11111")
        dismiss(animated: true, completion: nil)
    }
 
}


extension RowDetailViewController: UITextFieldDelegate{
   func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            updateBorder(color: .fucsiaColor(), border: accountTextFieldBorder)
        case 2:
            updateBorder(color: .fucsiaColor(), border: keyTextFieldBorder)
        default:
            break
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            updateBorder(color: .systemGray2, border: accountTextFieldBorder)
        default:
            updateBorder(color: .systemGray2, border: keyTextFieldBorder)
        }
    }
}
    
