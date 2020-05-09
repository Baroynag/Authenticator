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
    
//    Если надо будет из этого vc передать что-нибудь назад
    weak var delegate: VC2Delegate?
    
    private var isTimeBased = true
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    private let accountText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "account"
        return textField
    }()
    
    private let keyText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "key"
        return textField
    }()
    
    private let keyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let switchControl: UISwitch = {
        
        let swtch = UISwitch(frame: CGRect(x: 0, y:  5, width: 50, height: 50))
        swtch.isOn = true
        swtch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

        return swtch
    }()
    
    private let switchLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let switchLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public var editedText: String? {
        didSet{
            guard let editedText = editedText else {return}
            accountText.text = editedText
        }
    }
    
    // MARK: - Inits
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: Functions
    
    private func setupControllers(){
        setupTextField(textField: accountText)
        setupTextField(textField: keyText)
        setupLabels(label: accountLabel, text: "Account")
        setupLabels(label: keyLabel, text: "Key")
        setupLabels(label: switchLabel, text: "Time-based")
    }
    
    private func setupView() {
       
        setupNavigationController()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
         view.backgroundColor = .systemGray5
        
        setupControllers()
        setupLayouts()
    }
    
    
    private func setupLayouts(){

         view.addSubview(accountLabel)
         NSLayoutConstraint.activate([
             accountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
             accountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             accountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             accountLabel.heightAnchor.constraint(equalToConstant: 40)
         ])
         
         view.addSubview(accountText)
         NSLayoutConstraint.activate([
             accountText.topAnchor.constraint(equalTo: accountLabel.safeAreaLayoutGuide.bottomAnchor, constant: 1),
             accountText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             accountText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             accountText.heightAnchor.constraint(equalToConstant: 40)
         ])
         
         view.addSubview(keyLabel)
         NSLayoutConstraint.activate([
             keyLabel.topAnchor.constraint(equalTo: accountText.bottomAnchor, constant: 24),
             keyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             keyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             keyLabel.heightAnchor.constraint(equalToConstant: 40)
         ])
         
         view.addSubview(keyText)
         NSLayoutConstraint.activate([
             keyText.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: 1),
             keyText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             keyText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             keyText.heightAnchor.constraint(equalToConstant: 80)
         ])
         
         view.addSubview(switchLayerView)
         NSLayoutConstraint.activate([
             switchLayerView.topAnchor.constraint(equalTo: keyText.bottomAnchor, constant: 20),
             switchLayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             switchLayerView.heightAnchor.constraint(equalToConstant: 40),
             switchLayerView.widthAnchor.constraint(equalToConstant: 50)
         ])
         
         switchLayerView.addSubview(switchControl)
         
         view.addSubview(switchLabel)
         NSLayoutConstraint.activate([
             switchLabel.topAnchor.constraint(equalTo: keyText.bottomAnchor, constant: 20),
             switchLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             switchLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
             switchLabel.heightAnchor.constraint(equalToConstant: 40)
         ])
    }
    
    private func setupTextField(textField: UITextField)  {
        textField.backgroundColor = .white
        textField.font = UIFont(name: "Lato-Light", size: 24)
        textField.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    private func setupLabels(label: UILabel, text: String){
            
        let font = UIFont(name: "Lato-Light", size: 24)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = 15.0

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]

        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
       
        label.attributedText =  attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white

    }

    
    // MARK: - Handlers
    
    @objc private func handleSave(){
        
        print ("save")
        
        var authItem = Authenticator()
        
        authItem.account = accountText.text
        authItem.key = keyText.text
        authItem.timeBased = isTimeBased
        delegate?.titleDidChange(newAuthItem: authItem)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func switchValueChanged(_ sender:UISwitch!){

        isTimeBased = sender.isOn

    }
    
}


   
    

