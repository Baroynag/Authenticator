//
//  AuthenticatorViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 12.04.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class AuthenticatorViewController: UIViewController {

    // MARK: - Properties

    let cellId = "cellId"
    var tableView = UITableView()
    var timer: Timer?

    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addButton"), for: .normal)
        button.addTarget(self, action: #selector(pressAddButton), for: .touchUpInside)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.accessibilityIdentifier = "mainScreenAddButton"
        return button
    }()

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        setupAddButton()
        createTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }

    // MARK: - Handlers
    @objc private func pressAddButton() {
        showAddAccount()
    }

    @objc private func settingsTapped() {
        let settingsViewController = SettingsTableViewController()
        settingsViewController.modalPresentationStyle = .fullScreen
        settingsViewController.scannQROutput = self
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    @objc private func editTapped() {

        for cell in tableView.visibleCells {

            if let customCell = cell as? CustomCell {

                if !tableView.isEditing {
                    customCell.startEditing()
                } else {
                    customCell.stopEditing()
                }
            }
        }

        setupEditButton()
        addButton.isHidden = !tableView.isEditing
        tableView.isEditing  = !tableView.isEditing

    }

    // MARK: - Functions
    private func createTable() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    private func setupAddButton() {
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -8),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: -36),
            addButton.heightAnchor.constraint(equalToConstant: 80),
            addButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func configureNavBar() {
        setupNavigationController()
        navigationItem.title =  NSLocalizedString("Authenticator", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = false

        let settingsButton = UIBarButtonItem(
            image: UIImage(named: "settings"),
            style: .plain,
            target: self,
            action: #selector(settingsTapped))
        settingsButton.tintColor = UIColor.label

        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))

        editButton.tintColor = UIColor.label
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = settingsButton

    }

    private func showAddAccount() {
        let addAccountViewController = AddAccountViewController()
        addAccountViewController.output = self
        present(addAccountViewController, animated: true)
    }

    private func setupEditButton() {

        if !tableView.isEditing {
            let saveButton = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(editTapped))
            navigationItem.leftBarButtonItem = saveButton

        } else {
            let editButton = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(editTapped))
            navigationItem.leftBarButtonItem = editButton
        }
    }

}

// MARK: - UITableViewDataSource
extension AuthenticatorViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthenticatorModel.shared.sotpPersistentTokenItems.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let item = AuthenticatorModel.shared.sotpPersistentTokenItems[indexPath.row]
        if let customCell = cell as? CustomCell {
            customCell.authItem = item
            customCell.copyButton.tag = indexPath.row
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension AuthenticatorViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if let cell = tableView.cellForRow(at: indexPath) as? CustomCell,
           tableView.isEditing {
            cell.stopEditing()
        }
        if editingStyle == .delete {
            AuthenticatorModel.shared.deleteData(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CustomCell {
            cell.copyToClipBoard()
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        AuthenticatorModel.shared.swapPriority(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)

    }

}

// MARK: - Timer
extension AuthenticatorViewController {

    private func createTimer() {

        if timer == nil {

            let timer = Timer(timeInterval: 1.0,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)

            RunLoop.current.add(timer, forMode: .common)

            timer.tolerance = 0.1

            self.timer = timer
        }
    }

    @objc func updateTimer() {

        guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }

        for indexPath in visibleRowsIndexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? CustomCell {
                cell.updateTimerInfoLabel()
            }
        }
    }

}

extension AuthenticatorViewController: AddAccountViewControllerOutput {
    func reloadMainTableView() {
        tableView.reloadData()
    }
}

extension AuthenticatorViewController: SOTPScanQRViewControllerOutput {
    func  didFound(success: Bool) {
        if !success {
            let title = NSLocalizedString("Data loaded", comment: "")
            let alert = UIAlertController.alertWithOk(title: title)
            present(alert, animated: true)
            return
        }
        
        tableView.reloadData()
    }
}
