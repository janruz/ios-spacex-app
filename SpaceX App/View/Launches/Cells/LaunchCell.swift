//
//  LaunchCell.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit

class LaunchCell: UITableViewCell {
    
    //MARK: - Properties
    
    private let successIconLabel = IconLabelView()
    
    private let nameLabel = UILabel()
    
    private let detailLabel = UILabel()
    
    static let reuseID = "LaunchCell"
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Data

extension LaunchCell {
    
    func configure(with launchData: LaunchViewData) {
        
        nameLabel.text = launchData.name
        detailLabel.text = launchData.details
        
        successIconLabel.configure(
            systemImageName: launchData.successIconName,
            text: launchData.successLabelText,
            tintColor: launchData.successColor
        )
    }
}

//MARK: - Layout

extension LaunchCell {
    
    private func setup() {
        accessoryType = .disclosureIndicator
        
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        nameLabel.numberOfLines = 2
        
        detailLabel.font = UIFont.systemFont(ofSize: 16)
        detailLabel.numberOfLines = 3
    }
    
    private func layout() {
        contentView.addSubview(successIconLabel)
        successIconLabel.constrain(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            constantTop: 12,
            constantLeading: 12
        )
        
        contentView.addSubview(nameLabel)
        nameLabel.constrain(
            top: successIconLabel.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            constantTop: 16,
            constantLeading: 12,
            constantTrailing: -12
        )
        
        contentView.addSubview(detailLabel)
        detailLabel.constrain(
            top: nameLabel.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            constantTop: 12,
            constantLeading: 12,
            constantBottom: -12,
            constantTrailing: -12
        )
        detailLabel.setContentHuggingPriority(UILayoutPriority(100), for: .vertical)
    }
}
