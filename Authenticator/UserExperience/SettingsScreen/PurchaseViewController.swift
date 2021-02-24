//
//  PurchaseViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 08.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit
import StoreKit

final class PurchaseViewController: UIViewController {

    // MARK: - Properties

    // review: странно что активитиИндиктор создается по другому
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let imageView: UIImageView = {
        let image = UIImage(named: Constants.purchaseGemIconName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.textColor = .fucsiaColor
        textField.font = .largeFont
        textField.textAlignment = .center
        textField.text = Constants.supportString
        textField.isUserInteractionEnabled = false

        return textField
    }()

    private let descriprionTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.textColor = .label
        textField.font = .normalFont
        textField.textAlignment = .center
        textField.autocapitalizationType = .words
        textField.text = Constants.descriptionText
        textField.isUserInteractionEnabled = false

        return textField
    }()

    private let oneDollarPurchase: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.normalFont
        button.addTarget(self, action: #selector(handlePurchase), for: .touchUpInside)

        return button
    }()

    private let fiveDollarPurchase: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .fucsiaColor
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.normalFont
        button.addTarget(self, action: #selector(handleFiveDollarPurchase), for: .touchUpInside)

        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)

        return button
    }()

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setupLayout()
        activityIndicator.hidesWhenStopped = true
    }

    // MARK: - Functions
    private func setupLayout() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 128),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 102),
            imageView.widthAnchor.constraint(equalToConstant: 102)
        ])

        view.addSubview(titleField)
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 16),
            titleField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 8),
            titleField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -8),
            titleField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(descriprionTextField)
        NSLayoutConstraint.activate([
            descriprionTextField.topAnchor.constraint(
                equalTo: titleField.bottomAnchor,
                constant: 8),
            descriprionTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 8),
            descriprionTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -8),
            descriprionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriprionTextField.heightAnchor.constraint(equalToConstant: 100)
        ])

        let oneDollarTitle = Purchases.default.products?[Constants.oneDollarProductID]?.localizedPrice
        oneDollarPurchase.setTitle(oneDollarTitle, for: .normal)
        view.addSubview(oneDollarPurchase)
        NSLayoutConstraint.activate([
            oneDollarPurchase.topAnchor.constraint(
                equalTo: descriprionTextField.bottomAnchor,
                constant: 32),
            oneDollarPurchase.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oneDollarPurchase.heightAnchor.constraint(equalToConstant: 50),
            oneDollarPurchase.widthAnchor.constraint(equalToConstant: 280)
        ])

        let fiveDollarTitletitle = Purchases.default.products?[Constants.fiveDollarProductID]?.localizedPrice
        fiveDollarPurchase.setTitle(fiveDollarTitletitle, for: .normal)
        view.addSubview(fiveDollarPurchase)
        NSLayoutConstraint.activate([
            fiveDollarPurchase.topAnchor.constraint(equalTo: oneDollarPurchase.bottomAnchor, constant: 8),
            fiveDollarPurchase.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fiveDollarPurchase.heightAnchor.constraint(equalToConstant: 50),
            fiveDollarPurchase.widthAnchor.constraint(equalToConstant: 280)
        ])

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16),
            cancelButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 16),
            cancelButton.widthAnchor.constraint(equalToConstant: 16)
        ])
    }

    // MARK: - Handlers
    @objc private func handlePurchase() {
        showSpinner()
        oneDollarPurchase.isEnabled = false

        Purchases.default.purchaseProduct(productId: Constants.oneDollarProductID) { [weak self] _ in
            self?.hideSpinner()
            self?.oneDollarPurchase.isEnabled = true
        }
    }
  
    @objc func handleFiveDollarPurchase() {
        showSpinner()
        oneDollarPurchase.isEnabled = false

        Purchases.default.purchaseProduct(productId: Constants.fiveDollarProductID) { [weak self] _ in
            self?.hideSpinner()
            self?.oneDollarPurchase.isEnabled = true
        }
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Constants
    private enum Constants {
        static let fiveDollarProductID = "am.baroynag.SOTP.FiveDollarDonation"
        static let oneDollarProductID = "am.baroynag.SOTP.OneDollarDonation"

        static let purchaseGemIconName = "purchase_gem"

        static let supportString = NSLocalizedString("Support", comment: "")
        static let descriptionText = NSLocalizedString(
            "Please consider to support this open source project",
            comment: "")

        static let gratitudeText = NSLocalizedString("Thank you for your support!", comment: "")

        static let actionTitle = NSLocalizedString("Ok", comment: "")
    }
}

extension PurchaseViewController {
    func updateButton(_ button: UIButton, with product: SKProduct) {
        let title = "\(product.title ?? product.productIdentifier) for \(product.localizedPrice)"
        button.setTitle(title, for: .normal)
    }

    func showSpinner() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func hideSpinner() {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(
            title: "",
            message: Constants.gratitudeText,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: Constants.actionTitle,
            style: .default,
            handler: nil)

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
