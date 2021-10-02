//
//  SettingsTableViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class SettingsTableViewController: SOTPScanQRViewController {

    let cellId = "settingsCellId"
    let cellWithButtonId = "settingsCellWithButtonId"
    var tableView = UITableView()

    let settingsList = [
        NSLocalizedString("Support this project", comment: ""),
        NSLocalizedString("Transfer data", comment: ""),
        NSLocalizedString("Load from file", comment: ""),
        NSLocalizedString("Load from Google Authenticator", comment: ""),
        NSLocalizedString("About SOTP", comment: "")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        setupView()
    }

    private func createTable() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SettingsTableViewCellWithButton.self, forCellReuseIdentifier: cellWithButtonId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    private func setupView() {
        setupNavigationController()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        // review: В контсанты
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        view.backgroundColor = UIColor.systemBackground
    }
}

extension SettingsTableViewController: SettingsTableViewCellWithButtonOutput {
    func didTapPurchase() {
        let purchaseViewController = PurchaseViewController()
        present(purchaseViewController, animated: true, completion: nil)
    }
}

extension SettingsTableViewController: UIDocumentPickerDelegate {

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var title = NSLocalizedString("Wrong password", comment: "")
        if let fileUrl = urls.first {
            dismiss(animated: true) { [weak self ] in
                guard let self = self else {
                    return
                }

                let promtForPassword = UIAlertController.promptForPassword { (pass) in
                    if let pass = pass {
                        if Backup.getFileContent(fileURL: fileUrl, password: pass) {
                            self.scannQROutput?.actionAfterQRScanning(isError: false)
                            title = NSLocalizedString("Data loaded", comment: "")
                        }
                    }
                    let alert = UIAlertController.alertWithOk(title: title)
                    self.present(alert, animated: true)
                }
                self.present(promtForPassword, animated: true)
            }
        }
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension SettingsTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numbersOfRows = 0
        if section == 0 {
            numbersOfRows = 1
        } else {
            numbersOfRows = settingsList.count - 1
        }

        return numbersOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellWithButtonId,
                for: indexPath)
            if let cellWithButton = cell as? SettingsTableViewCellWithButton {
                cellWithButton.title = settingsList[indexPath.row]
                cellWithButton.output = self
                cellWithButton.purchaseButton.tag = indexPath.row
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellId, for: indexPath)

            if let customCell = cell as? SettingsTableViewCell {
                customCell.accessoryType = .disclosureIndicator
                customCell.title = settingsList[indexPath.row + 1]
            }
            return cell

        }

    }
}

extension SettingsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 1 {
            if traitCollection.userInterfaceStyle == .light {
                view.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
            } else {
                view.backgroundColor =   UIColor(red: 0.158, green: 0.158, blue: 0.158, alpha: 1)
            }
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            return
        }

        if indexPath.row == 0 {
            let passwordViewController = PasswordViewController()
            present(passwordViewController, animated: true)

        } else if indexPath.row == 1 {
            chooseDocument(vcWithDocumentPicker: self)
        } else if indexPath.row == 2 {
            loadFromGoogleAuthenticator()
        } else if  indexPath.row == 3 {
            let aboutVc = AboutViewController()
            present(aboutVc, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
