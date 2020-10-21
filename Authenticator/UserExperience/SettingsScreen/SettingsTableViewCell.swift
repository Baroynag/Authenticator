//
//  SettingsTableViewCell.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 30.08.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    public var title: String?{
        didSet{
            if let title = title{
                cellTitle.setLabelAtributedText(fontSize: 17, text: title, aligment: .left, indent: 0.0)
            }
        }
    }
    private let cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupView(){
        addSubview(cellTitle)
     
        NSLayoutConstraint.activate([
            cellTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            cellTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cellTitle.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
            
            ])
    }

}
