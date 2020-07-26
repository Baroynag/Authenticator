//
//  PasswordViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 16.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit



class PasswordViewController: UIViewController {
    
    //    MARK:- Properties
    
    public var callBack: ((String) -> ())?
    
    private let offsetX = 24.0
    private let offsetY = 64.0
    private let textFieldHeigth = 80.0
    private var textFieldWidth: Double = 0.0
    
    private var passwordTextField = UITextFieldWithBottomBorder()
    private var confirmPasswordTextField = UITextFieldWithBottomBorder()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .fucsiaColor()
        button.setTitle(NSLocalizedString("Ok", comment: "") , for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
     }()
    
    //    MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupView()
    }
    
    //  MARK:- Functions
    private func setupView(){
        view.backgroundColor = UIColor.systemBackground
        
        textFieldWidth = Double(view.frame.width) - offsetX * 2
        
        passwordTextField = UITextFieldWithBottomBorder(frame: CGRect(x: offsetX, y: offsetY*2, width: textFieldWidth, height: textFieldHeigth))
        view.addSubview(passwordTextField)
        passwordTextField.returnKeyType = UIReturnKeyType.next
        
        confirmPasswordTextField = UITextFieldWithBottomBorder(frame: CGRect(x: offsetX, y: textFieldHeigth + offsetY * 2, width: textFieldWidth, height: textFieldHeigth))
        view.addSubview(confirmPasswordTextField)
        
        
        setupTextField(textField: passwordTextField, placeholderText: NSLocalizedString("Password", comment: "") , tag: 1)
             setupTextField(textField: confirmPasswordTextField, placeholderText: NSLocalizedString("Confirm password", comment: "") , tag: 2)
        
        view.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 48),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 80),
            confirmButton.widthAnchor.constraint(equalToConstant: 80)
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
        textField.isSecureTextEntry = true
    }
 
    private func showErrorAlert(errorText: String){
        let alert = UIAlertController(title: "", message: errorText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Ok", comment: "") , comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //    MARK: - Handlers
    @objc private func handleConfirmButton(){
        do{
            let isValidPassword = try PasswordError.cheackPassword(passOne: passwordTextField.text, passTwo: confirmPasswordTextField.text)
            if isValidPassword {
                
                navigationController?.popViewController(completion: {  [weak self] in
                    if let password = self?.passwordTextField.text{
                        self?.callBack?(password)
                    }
                })
            }
        } catch {
            showErrorAlert(errorText: error.localizedDescription)
        }
    }
}

extension PasswordViewController: UITextFieldDelegate{
   
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
