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

func makeSelectOrderActionSheet(
    onSelect: @escaping (LaunchSortOrder) -> Void
) -> UIAlertController {
    
    let actionSheet = UIAlertController(
        title: NSLocalizedString(
            Strings.Launches.Sorting.title,
            comment: "Rocket launches sort order selection action sheet title"
        ),
        message: nil,
        preferredStyle: UIAlertController.Style.actionSheet
    )
    
    actionSheet.addAction(UIAlertAction(
        title: NSLocalizedString(
            Strings.Launches.Sorting.dateAsc,
            comment: "Rocket launches date asceding sort order"
        ).capitalized,
        style: UIAlertAction.Style.default,
        handler: { (action) -> Void in
            onSelect(.dateAsc)
        }
    ))
    
    actionSheet.addAction(UIAlertAction(
        title: NSLocalizedString(
            Strings.Launches.Sorting.dateDesc,
            comment: "Rocket launches date descending sort order"
        ).capitalized,
        style: UIAlertAction.Style.default,
        handler: { (action) -> Void in
            onSelect(.dateDesc)
        }
    ))
    
    actionSheet.addAction(UIAlertAction(
        title: NSLocalizedString(Strings.cancel, comment: "Hide the action sheet"),
        style: UIAlertAction.Style.cancel,
        handler: { (action) -> Void in
        }
    ))
    
    return actionSheet
}
