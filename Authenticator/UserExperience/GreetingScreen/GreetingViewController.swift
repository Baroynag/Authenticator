//
//  GreetingViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 29.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class GreetingViewController: UIViewControllerWithDocumentPicker {

    //    MARK: - Properties
    weak var addItemDelegate: AddItemDelegate?
    
    private let imageView: UIImageView = {
         let im = UIImage(named: "greeting")
         let iv = UIImageView(image: im)
         iv.contentMode = .scaleAspectFit
         iv.translatesAutoresizingMaskIntoConstraints = false
         return iv
     }()
    
    private var  topImageContainerView = UIView()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Welcome to", comment: "")
        label.setLabelAtributedText(fontSize: 28, text: text, aligment: .center, indent: 0.0)
        return label
    }()
    
    private let sotpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("SOTP", comment: "")
        label.setLabelAtributedText(fontSize: 28, text: text, aligment: .center, indent: 0.0, color: .fucsiaColor())
        return label
    }()
    
    private let setupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        let text = NSLocalizedString("Setup one time password", comment: "")
        label.setLabelAtributedText(fontSize: 23, text: text, aligment: .center, indent: 0.0)
        return label
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor()
        button.setTitle(NSLocalizedString("Create", comment: "") , for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        return button
    }()
    
    let loadButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .fucsiaColor()
            button.setTitle(NSLocalizedString("Load from backup", comment: "") , for: .normal)
            button.layer.cornerRadius = 30
            button.clipsToBounds = true
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont(name: "Lato-Light", size: 18)
            button.addTarget(self, action: #selector(handleLoad), for: .touchUpInside)
            return button
        }()
    
    
    //    MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    //    MARK: - Handlers
    @objc private func handleCreate() {
        let rowDetailViewController = RowDetailViewController()
        rowDetailViewController.delegate = addItemDelegate
        rowDetailViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(rowDetailViewController, animated: true)
    }

    @objc private func handleLoad() {
       chooseDocument {(isEnded) in
           print ("isEnded")
       }
    }
    
    //    MARK: - Functions
    private func setupLayout(){
        
        view.backgroundColor = UIColor.systemBackground
       
        view.addSubview(topImageContainerView)
         topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            topImageContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             topImageContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             topImageContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
          ])

         
         topImageContainerView.addSubview(imageView)
         NSLayoutConstraint.activate([
             imageView.topAnchor.constraint(equalTo: topImageContainerView.topAnchor),
             imageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
             imageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.8)
         ])
     
        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: 16),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.widthAnchor.constraint(equalToConstant: 160)
        ])
        view.addSubview(sotpLabel)
        NSLayoutConstraint.activate([
            sotpLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            sotpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sotpLabel.widthAnchor.constraint(equalToConstant: 160)
        ])
        view.addSubview(setupLabel)
        NSLayoutConstraint.activate([
            setupLabel.topAnchor.constraint(equalTo: sotpLabel.bottomAnchor, constant: 8),
            setupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setupLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            setupLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
     
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: setupLabel.bottomAnchor, constant: 24),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        view.addSubview(loadButton)
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 24),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.heightAnchor.constraint(equalToConstant: 60),
            loadButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
}
