//
//  RocketLaunchCell.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit

class RocketLaunchCell: UITableViewCell {
    
    //MARK: - Properties
    
    var rocketLaunch: RocketLaunch? {
        didSet {
            upcomingIconLabel.setUp(
                systemImageName: rocketLaunch?.upcoming == true ? "clock.fill" : "clock.badge.checkmark.fill",
                text: rocketLaunch?.upcoming == true ? "Upcoming" : "Past",
                tintColor: rocketLaunch?.upcoming == true ? .systemOrange : .systemBlue
            )
            
            var successIconImageName = ""
            var successText = ""
            var successTintColor = UIColor.systemBlue
            
            if let success = rocketLaunch?.success {
                
                if success {
                    successIconImageName = "checkmark.seal.fill"
                    successText = "Successful"
                    successTintColor = .systemGreen
                    
                } else {
                    successIconImageName = "clear.fill"
                    successText = "Failed"
                    successTintColor = .systemRed
                }
                
            } else {
                successIconImageName = "questionmark.circle.fill"
                successText = "Unknown"
                successTintColor = .systemYellow
            }
            
            successIconLabel.setUp(
                systemImageName: successIconImageName,
                text: successText,
                tintColor: successTintColor
            )

            nameLabel.text = rocketLaunch?.name
            detailLabel.text = rocketLaunch?.details
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
        addSubview(upcomingIconLabel)
        upcomingIconLabel.constrain(
            top: topAnchor,
            leading: leadingAnchor,
            constantTop: 12,
            constantLeading: 12
        )
        
        addSubview(successIconLabel)
        successIconLabel.constrain(
            top: topAnchor,
            leading: upcomingIconLabel.trailingAnchor,
            constantTop: 12,
            constantLeading: 24
        )
        
        addSubview(nameLabel)
        nameLabel.constrain(
            top: upcomingIconLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            constantTop: 16,
            constantLeading: 12,
            constantTrailing: -12
        )
        
        addSubview(detailLabel)
        detailLabel.constrain(
            top: nameLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            constantTop: 12,
            constantLeading: 12,
            constantBottom: -12,
            constantTrailing: -12
        )
        detailLabel.setContentHuggingPriority(UILayoutPriority(100), for: .vertical)
    }
}
