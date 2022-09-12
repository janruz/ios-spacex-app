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
            upcomingIcon.image = rocketLaunch?.upcoming == true ? UIImage(systemName: "clock.fill") : UIImage(systemName: "checkmark.circle.fill")
            nameLabel.text = rocketLaunch?.name
            detailLabel.text = rocketLaunch?.details
        }
    }
    
    private let upcomingIcon = UIImageView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
        addSubview(upcomingIcon)
        upcomingIcon.constrain(
            top: topAnchor,
            leading: leadingAnchor,
            constantTop: 12,
            constantLeading: 12,
            widthConstant: 24,
            heightConstant: 24
        )
        
        addSubview(nameLabel)
        nameLabel.constrain(
            top: upcomingIcon.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            constantTop: 8,
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
    }
}
