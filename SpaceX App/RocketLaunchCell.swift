//
//  RocketLaunchCell.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit

class RocketLaunchCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var rocketLaunch: RocketLaunch? {
        didSet {
            nameLabel.text = rocketLaunch?.name
            detailLabel.text = rocketLaunch?.details
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    private func configureUI() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .secondarySystemBackground
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(detailLabel)
        
        addSubview(stack)
        stack.fill(self, withPaddingOf: 12)
    }
}
