//
//  ViewFactory.swift
//  SpaceX App
//
//  Created by Jan Růžička on 26.09.2022.
//

import UIKit

func makeStack(
    _ axis: NSLayoutConstraint.Axis,
    _ spacing: CGFloat,
    _ distribution: UIStackView.Distribution,
    _ subviews: [UIView] = []
) -> UIStackView {
    
    let stack = UIStackView(arrangedSubviews: subviews)
    stack.axis = axis
    stack.spacing = spacing
    stack.distribution = distribution
    
    return stack
}

func makeStack(
    _ axis: NSLayoutConstraint.Axis,
    _ spacing: CGFloat,
    _ distribution: UIStackView.Distribution,
    _ alignment: UIStackView.Alignment,
    _ subviews: [UIView] = []
) -> UIStackView {
    
    let stack = UIStackView(arrangedSubviews: subviews)
    stack.axis = axis
    stack.spacing = spacing
    stack.distribution = distribution
    stack.alignment = alignment
    
    return stack
}
