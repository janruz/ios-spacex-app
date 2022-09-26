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
    
    let rocketName: String
    
    let rocketStatusIconName: String
    let rocketStatusLabelText: String
    let rocketStatusColor: UIColor
    
    let launchpadName: String
    
    let launchpadStatusIconName: String
    let launchpadStatusLabelText: String
    let launchpadStatusColor: UIColor
    
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
        
        rocketName = launch.rocket.name
        
        rocketStatusIconName = launch.rocket.active ? "checkmark.seal.fill" : "clear.fill"
        rocketStatusLabelText = launch.rocket.active ? "Active" : "Inactive"
        rocketStatusColor = launch.rocket.active ? UIColor.systemMint : UIColor.systemRed
        
        launchpadName = launch.launchpad.name
        
        launchpadStatusIconName = "checkmark.seal.fill"
        launchpadStatusLabelText = launch.launchpad.status.rawValue.capitalized
        launchpadStatusColor = .systemTeal
    }
}
