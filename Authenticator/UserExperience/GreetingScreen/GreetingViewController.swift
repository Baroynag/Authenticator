//
//  GreetingViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 29.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class GreetingViewController: UIViewController{
    
    //    MARK: - Properties
    weak var addItemDelegate: AddItemDelegate?
    weak var refreshTableDelegate: RefreshTableDelegate?
    
    private let imageView: UIImageView = {
         let im = UIImage(named: "greeting")
         let iv = UIImageView(image: im)
         iv.contentMode = .scaleAspectFit
         iv.translatesAutoresizingMaskIntoConstraints = false
         return iv
     }()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Welcome to", comment: "")
        label.setLabelAtributedText(fontSize: 24, text: text, aligment: .center, indent: 0.0)
        return label
    }()
    
    private let sotpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("SOTP", comment: "")
        label.setLabelAtributedText(fontSize: 32, text: text, aligment: .center, indent: 0.0, color: .fucsiaColor())
        return label
    }()
    
    private let setupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Setup one time password", comment: "")
        label.setLabelAtributedText(fontSize: 20, text: text, aligment: .center, indent: 0.0)
        return label
    }()
    
    let createButton: RoundedButtonWithShadow = {
        let button = RoundedButtonWithShadow(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Create", comment: "") , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        return button
    }()
    
    let loadButton: RoundedButtonWithShadow = {
            let button = RoundedButtonWithShadow(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(NSLocalizedString("Load from backup", comment: "") , for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            button.addTarget(self, action: #selector(handleLoad), for: .touchUpInside)
            return button
        }()
    
    
    //    MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupLayout()
    }
    
    //    MARK: - Handlers
    @objc private func handleCreate() {
        let rowDetailViewController = AddAccountViewController()
        rowDetailViewController.delegate = addItemDelegate
        rowDetailViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(rowDetailViewController, animated: true)
    }

    @objc private func handleLoad() {
    
        self.chooseDocument(vcWithDocumentPicker: self) {
                print("chooseDocument end")
        }
    }
    
    //    MARK: - Functions
    private func setupLayout(){
     
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor.systemBackground
   
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 145),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 199)
         ])
     
        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor, constant: 19),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.addSubview(sotpLabel)
        NSLayoutConstraint.activate([
            sotpLabel.topAnchor.constraint(lessThanOrEqualTo: greetingLabel.bottomAnchor, constant: 14),
            sotpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.addSubview(setupLabel)
        NSLayoutConstraint.activate([
            setupLabel.topAnchor.constraint(lessThanOrEqualTo: sotpLabel.bottomAnchor, constant: 8),
            setupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setupLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            setupLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
     
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(lessThanOrEqualTo: setupLabel.bottomAnchor, constant: 30),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.widthAnchor.constraint(equalToConstant: 320)
        ])
        
        view.addSubview(loadButton)
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(lessThanOrEqualTo: createButton.bottomAnchor, constant: 22),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.heightAnchor.constraint(equalToConstant: 50),
            loadButton.widthAnchor.constraint(equalToConstant: 320)
        ])
    }
}
