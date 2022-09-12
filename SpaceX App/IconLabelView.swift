//
//  IconLabelView.swift
//  SpaceX App
//
//  Created by Jan Růžička on 12.09.2022.
//

import Foundation
import UIKit

class IconLabelView: UIView {
    
    //MARK: - Properties
    
    private let imageView = UIImageView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
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
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        addSubview(stackView)
        stackView.fill(self)
    }
    
    //MARK: - Functionality
    
    func setUp(systemImageName: String, text: String, tintColor: UIColor) {
        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = tintColor
        
        label.text = text
        label.textColor = tintColor
    }
}
