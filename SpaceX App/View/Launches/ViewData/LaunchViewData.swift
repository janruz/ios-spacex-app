//
//  LaunchViewData.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import Foundation
import UIKit

struct LaunchViewData {
    
    //MARK: - Properties
    
    let name: String
    let details: String
    
    let successIconName: String
    let successLabelText: String
    let successColor: UIColor
    
    let rocketText: NSAttributedString
    let launchpadText: NSAttributedString
    
    //MARK: - Lifecycle
    
    init(from launch: Launch) {
        name = launch.name
        details = launch.details ?? ""
        
        if let successful = launch.successful {
            
            if successful {
                successIconName = "checkmark.seal.fill"
                successLabelText = NSLocalizedString(Strings.RocketLaunches.successful, comment: "Successful rocket launch label")
                successColor = .systemGreen
                
            } else {
                successIconName = "clear.fill"
                successLabelText = NSLocalizedString(Strings.RocketLaunches.failed, comment: "Failed rocket launch label")
                successColor = .systemRed
            }
            
        } else {
            successIconName = "questionmark.circle.fill"
            successLabelText = NSLocalizedString(Strings.RocketLaunches.statusUnknown, comment: "Label for rocket launch with unknown status (success/failure)")
            successColor = .systemYellow
        }
        
        let rocketString = NSMutableAttributedString(string: "Rocket: ", attributes: [:])
        let rocketNameString = NSAttributedString(
            string: launch.rocket.name,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
        )
        rocketString.append(rocketNameString)
        rocketText = rocketString
    
        let launchpadString = NSMutableAttributedString(string: "Launchpad: ", attributes: [:])
        let launchpadNameString = NSAttributedString(
            string: launch.launchpad.name,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
        )
        launchpadString.append(launchpadNameString)
        launchpadText = launchpadString
    }
}
