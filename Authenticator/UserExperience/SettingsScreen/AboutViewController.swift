//
//  AboutViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 15.11.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    let cancelButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBackground
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private let imageView: UIImageView = {
         let im = UIImage(named: "greeting")
         let iv = UIImageView(image: im)
         iv.contentMode = .scaleAspectFit
         iv.translatesAutoresizingMaskIntoConstraints = false
         return iv
     }()
    
    private var descriprionTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.textColor = UIColor.label
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.textAlignment = .center
        textField.autocapitalizationType = .words
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let onepenGitHubRepo: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setTitle("Open GitHub repo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handleOpenLink), for: .touchUpInside)
        return button
    }()
    
    let aboutApp = NSLocalizedString("SOTP is an open source app. It does not collect any personal information.", comment: "")
    
    let sendMail = NSLocalizedString("If you have any suggestions, you can send an e-mail to baroynag@gmail.com", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 16),
            cancelButton.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 145),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 199)
         ])
     
        view.addSubview(descriprionTextField)
        descriprionTextField.text = aboutApp
        NSLayoutConstraint.activate([
            descriprionTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            descriprionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            descriprionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            descriprionTextField.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(onepenGitHubRepo)
        NSLayoutConstraint.activate([
            onepenGitHubRepo.topAnchor.constraint(equalTo: descriprionTextField.bottomAnchor, constant: 32),
            onepenGitHubRepo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onepenGitHubRepo.heightAnchor.constraint(equalToConstant: 50),
            onepenGitHubRepo.widthAnchor.constraint(equalToConstant: 280)
        ])
        
    }
    
    @objc func handleOpenLink() {
        guard let url = URL(string: "https://github.com/Baroynag/Authenticator") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
}