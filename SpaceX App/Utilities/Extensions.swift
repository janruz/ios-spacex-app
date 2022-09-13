//
//  Extensions.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import UIKit

extension UIView {
    
    func constrain(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        constantTop: CGFloat = 0,
        constantLeading: CGFloat = 0,
        constantBottom: CGFloat = 0,
        constantTrailing: CGFloat = 0,
        widthConstant: CGFloat? = nil,
        heightConstant: CGFloat? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: constantTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: constantLeading).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: constantBottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: constantTrailing).isActive = true
        }
        
        if let widthConstant = widthConstant {
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        
        if let heightConstant = heightConstant {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }
    
    func fill(_ view: UIView, withPaddingOf padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        constrain(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, constantTop: padding, constantLeading: padding, constantBottom: -padding, constantTrailing: -padding)
    }
}
