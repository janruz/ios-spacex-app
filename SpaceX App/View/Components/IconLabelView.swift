//
//  IconLabelView.swift
//  SpaceX App
//
//  Created by Jan Růžička on 12.09.2022.
//

import UIKit

class IconLabelView: UIView {
    
    //MARK: - Properties
    
    private let imageView = UIImageView()
    
    private let label = UILabel()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 20 + 8 + label.frame.width, height: 20)
    }
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functionality
    
    func configure(systemImageName: String, text: String, tintColor: UIColor) {
        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = tintColor
        
        label.text = text
        label.textColor = tintColor
        
        invalidateIntrinsicContentSize()
    }
}

//MARK: - Layout

extension IconLabelView {
    
    private func setup() {
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func layout() {
        addSubview(imageView)
        imageView.constrain(
            top: topAnchor,
            leading: leadingAnchor,
            widthConstant: 20,
            heightConstant: 20
        )
        
        addSubview(label)
        label.constrain(
            top: topAnchor,
            leading: imageView.trailingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            constantLeading: 8
        )
    }
}
