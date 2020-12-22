//
//  SettingsTableViewController.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerOutput: class {
    func didLoadBackup()
}

class SettingsTableViewController: UITableViewController {
    weak var output: SettingsTableViewControllerOutput?

    let cellId = "settingsCellId"
    let cellWithButtonId = "settingsCellWithButtonId"

    let settingsList = [
        NSLocalizedString("Support this project", comment: ""),
        NSLocalizedString("Create backup", comment: ""),
        NSLocalizedString("Load from Backup", comment: ""),
        NSLocalizedString("About SOTP", comment: "")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SettingsTableViewCellWithButton.self, forCellReuseIdentifier: cellWithButtonId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        setupView()
    }

    private func setupView() {
        setupNavigationController()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        // review: В контсанты
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        view.backgroundColor = UIColor.systemBackground

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numbersOfRows = 0
        if section == 0 {
            numbersOfRows = 1
        } else {
            numbersOfRows = 3
        }

        return numbersOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            return
        }

        if indexPath.row == 0 {
            let passwordViewController = PasswordViewController()
            present(passwordViewController, animated: true)

        } else if indexPath.row == 1 {

            chooseDocument(vcWithDocumentPicker: self)
        } else if  indexPath.row == 2 {

            let aboutVc = AboutViewController()
            present(aboutVc, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
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
                            self.output?.didLoadBackup()
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
