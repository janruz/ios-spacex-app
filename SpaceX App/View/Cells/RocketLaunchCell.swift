//
//  RocketLaunchCell.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit

class RocketLaunchCell: UITableViewCell {
    
    //MARK: - Properties
    
    var viewData: RocketLaunchViewData? {
        didSet {
            guard let safeViewData = viewData else { return }
            
            nameLabel.text = safeViewData.name
            detailLabel.text = safeViewData.details
            
            upcomingIconLabel.setup(
                systemImageName: safeViewData.upcomingIconName,
                text: safeViewData.upcomingLabelText,
                tintColor: safeViewData.upcomingColor
            )
            
            successIconLabel.setup(
                systemImageName: safeViewData.successIconName,
                text: safeViewData.successLabelText,
                tintColor: safeViewData.successColor
            )
        }
    }
    
    private let upcomingIconLabel = IconLabelView()
    
    private let successIconLabel = IconLabelView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        
        return label
    }()
    
    static let reuseID = "RocketLaunchCell"
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    private func configureUI() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(upcomingIconLabel)
        upcomingIconLabel.constrain(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            constantTop: 12,
            constantLeading: 12
        )
        
        contentView.addSubview(successIconLabel)
        successIconLabel.constrain(
            top: contentView.topAnchor,
            leading: upcomingIconLabel.trailingAnchor,
            constantTop: 12,
            constantLeading: 24
        )
        
        contentView.addSubview(nameLabel)
        nameLabel.constrain(
            top: upcomingIconLabel.bottomAnchor,
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
