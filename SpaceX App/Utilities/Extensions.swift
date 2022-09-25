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
        width: NSLayoutDimension? = nil,
        height: NSLayoutDimension? = nil,
        widthConstant: CGFloat? = nil,
        heightConstant: CGFloat? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let safeTop = top {
            topAnchor.constraint(equalTo: safeTop, constant: constantTop).isActive = true
        }
        
        if let safeLeading = leading {
            leadingAnchor.constraint(equalTo: safeLeading, constant: constantLeading).isActive = true
        }
        
        if let safeBottom = bottom {
            bottomAnchor.constraint(equalTo: safeBottom, constant: constantBottom).isActive = true
        }
        
        if let safeTrailing = trailing {
            trailingAnchor.constraint(equalTo: safeTrailing, constant: constantTrailing).isActive = true
        }
        
        if let safeWidth = width {
            widthAnchor.constraint(equalTo: safeWidth).isActive = true
        }
        
        if let safeHeight = height {
            heightAnchor.constraint(equalTo: safeHeight).isActive = true
        }
        
        if let safeWidthConstant = widthConstant {
            widthAnchor.constraint(equalToConstant: safeWidthConstant).isActive = true
        }
        
        if let safeHeightConstant = heightConstant {
            heightAnchor.constraint(equalToConstant: safeHeightConstant).isActive = true
        }
        
        if let safeCenterX = centerX {
            centerXAnchor.constraint(equalTo: safeCenterX).isActive = true
        }
        
        if let safeCenterY = centerY {
            centerYAnchor.constraint(equalTo: safeCenterY).isActive = true
        }
    }
}
