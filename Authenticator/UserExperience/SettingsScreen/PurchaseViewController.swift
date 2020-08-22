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
         let im = UIImage(named: "greeting")
         let iv = UIImageView(image: im)
         iv.contentMode = .scaleAspectFit
         iv.translatesAutoresizingMaskIntoConstraints = false
         return iv
     }()
    
    private var  topImageContainerView = UIView()
    
    private var descriprionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground

        textField.textColor = UIColor.label
        textField.font = UIFont(name: "Lato-Light", size: 18)
        textField.textAlignment = .center
        textField.text = NSLocalizedString("Buy SOTP Authenticator and support this project", comment: "")
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.setTitle(NSLocalizedString("Bye", comment: "") , for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handlePurchase), for: .touchUpInside)
        return button
    }()
    
    let restoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.setTitle(NSLocalizedString("Restore", comment: "") , for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
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
       
        view.addSubview(topImageContainerView)
         topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            topImageContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             topImageContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             topImageContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6)
          ])

         
         topImageContainerView.addSubview(imageView)
         NSLayoutConstraint.activate([
             imageView.topAnchor.constraint(equalTo: topImageContainerView.topAnchor),
             imageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
             imageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.6)
         ])
     
        view.addSubview(descriprionTextField)
        NSLayoutConstraint.activate([
            descriprionTextField.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: 16),
            descriprionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            descriprionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            descriprionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

     
        
        
        view.addSubview(restoreButton)
        NSLayoutConstraint.activate([
            restoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            restoreButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            restoreButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            restoreButton.heightAnchor.constraint(equalToConstant: 60)

        ])
        
        view.addSubview(purchaseButton)
        NSLayoutConstraint.activate([
            purchaseButton.bottomAnchor.constraint(equalTo: restoreButton.topAnchor, constant: -8),
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            purchaseButton.heightAnchor.constraint(equalToConstant: 60)

        ])
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
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
