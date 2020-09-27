//
//  PurchaseViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 08.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController {

    //    MARK: - Properties

    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let imageView: UIImageView = {
         let im = UIImage(named: "purchase_gem")
         let iv = UIImageView(image: im)
         iv.contentMode = .scaleAspectFit
         iv.translatesAutoresizingMaskIntoConstraints = false
         return iv
     }()
    
    private var titleField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground

        textField.textColor = UIColor.fucsiaColor()
        textField.font = UIFont(name: "Lato-Light", size: 32)
        textField.textAlignment = .center
        textField.text = NSLocalizedString("Support", comment: "")
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private var descriprionTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.textColor = UIColor.label
        textField.font = UIFont(name: "Lato-Light", size: 18)
        textField.textAlignment = .center
        textField.autocapitalizationType = .words
        textField.text = NSLocalizedString("Please consider to support this open source project", comment: "")
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.setTitle(NSLocalizedString("Bye", comment: "") , for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handlePurchase), for: .touchUpInside)
        return button
    }()
    
    let restoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBackground
        button.setTitle(NSLocalizedString("Restore", comment: "") , for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderWidth  = 1.0
        button.layer.borderColor = CGColor(srgbRed: 1, green: 0.196, blue: 0.392, alpha: 1)
        button.clipsToBounds = true
        button.setTitleColor(.fucsiaColor(), for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBackground
        button.setImage(UIImage(named: "close"), for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    

    
    //    MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setupLayout()
        activityIndicator.hidesWhenStopped = true
    }
    
    //    MARK: - Functions
    private func updateInterface(products: [SKProduct]) {
        updateButton(purchaseButton, with: products[0])
    }
    
    private func setupLayout(){
        
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 128),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 101.6),
            imageView.widthAnchor.constraint(equalToConstant: 101.6)
         ])
     
        view.addSubview(titleField)
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            titleField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            titleField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(descriprionTextField)
        NSLayoutConstraint.activate([
            descriprionTextField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 8),
            descriprionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            descriprionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            descriprionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriprionTextField.heightAnchor.constraint(equalToConstant: 100)
        ])

        view.addSubview(purchaseButton)
        NSLayoutConstraint.activate([
            purchaseButton.topAnchor.constraint(equalTo: descriprionTextField.bottomAnchor, constant: 32),
            purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            purchaseButton.heightAnchor.constraint(equalToConstant: 50),
            purchaseButton.widthAnchor.constraint(equalToConstant: 280)
        ])
        
        view.addSubview(restoreButton)
        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 8),
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restoreButton.heightAnchor.constraint(equalToConstant: 50),
            restoreButton.widthAnchor.constraint(equalToConstant: 280)
        ])
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 16),
            cancelButton.widthAnchor.constraint(equalToConstant: 16)
        ])
        
    }
    
   //    MARK: - Handlers
    @objc private func handlePurchase() {
        print(#function)

        showSpinner()
        self.purchaseButton.isEnabled = false
        Purchases.default.purchaseProduct(productId: "am.baroynag.SOTP.HeartSticker") { [weak self] _ in
            
            self?.hideSpinner()
            self?.purchaseButton.isEnabled = true
            print("end")
            
        }
        
    }
    
    @objc func handleRestore(){
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }

}


extension PurchaseViewController {

    func updateButton(_ button: UIButton, with product: SKProduct) {
          let title = "\(product.title ?? product.productIdentifier) for \(product.localizedPrice)"
          button.setTitle(title, for: .normal)
      }
    
    func showSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
    }

    func hideSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
   
}
