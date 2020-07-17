//
//  PasswordViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 16.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

enum PasswordError: Error {
    case empty
    case short
    case notConfirmed
    case different
}

class PasswordViewController: UIViewController {
    
    //    MARK:- Properties

    
    let offsetX = 24.0
    let offsetY = 64.0
    let textFieldHeigth = 80.0
    var textFieldWidth: Double = 0.0
    
    private var passwordTextField = UITextFieldWithBottomBorder()
    private var confirmPasswordTextField = UITextFieldWithBottomBorder()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .fucsiaColor()
        button.setTitle("OK", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
         
        button.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
     }()
    
    
    //    MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        setupTextField(textField: passwordTextField, placeholderText: "Пароль", tag: 1)
             setupTextField(textField: confirmPasswordTextField, placeholderText: "Подтвердите пароль", tag: 2)
        
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
    
    func cheackPassword(passOne: String?, passTwo: String?) throws -> Bool {
        
        guard let passOne = passOne else {
            throw PasswordError.empty
        }
        
        guard let passTwo = passTwo else{
            throw PasswordError.notConfirmed
        }
        
        if passOne == "" {
            throw PasswordError.empty
        }
        
        if passTwo == "" {
            throw PasswordError.notConfirmed
        }
        
        if passOne != passTwo {
            throw PasswordError.different
        }
        
        return true
    }
    
    func showErrorAlert(errorText: String){
        let alert = UIAlertController(title: "", message: errorText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //    MARK: - Handlers
    @objc private func handleConfirmButton(){
        do{
            let isValidPassword = try cheackPassword(passOne: passwordTextField.text, passTwo: confirmPasswordTextField.text)
            if isValidPassword {
                dismiss(animated: true, completion: nil)
            }
        } catch PasswordError.empty{
            showErrorAlert(errorText: "Введие пароль!")
        } catch PasswordError.notConfirmed{
            showErrorAlert(errorText: "Введие подтверждение пароля!")
        } catch PasswordError.different{
            showErrorAlert(errorText: "Введенные пароли не совпадают")
        } catch{
            showErrorAlert(errorText: "Неизвестная ошибка")
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
