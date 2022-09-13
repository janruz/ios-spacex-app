//
//  RocketLaunchViewData.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import Foundation
import UIKit

struct RocketLaunchViewData {
    
    //MARK: - Properties
    
    let name: String
    let details: String
    
    let upcomingIconName: String
    let upcomingLabelText: String
    let upcomingColor: UIColor
    
    let successIconName: String
    let successLabelText: String
    let successColor: UIColor
    
    //MARK: - Lifecycle
    
    init(from rocketLaunch: RocketLaunch) {
        name = rocketLaunch.name
        details = rocketLaunch.details ?? ""
        
        if rocketLaunch.upcoming {
            upcomingIconName = "clock.fill"
            upcomingLabelText = NSLocalizedString(Strings.RocketLaunches.upcoming, comment: "Upcoming rocket launch label")
            upcomingColor = .systemOrange
        } else {
            upcomingIconName = "clock.badge.checkmark.fill"
            upcomingLabelText = NSLocalizedString(Strings.RocketLaunches.past, comment: "Past rocket launch label")
            upcomingColor = .systemBlue
        }
        
        if let successful = rocketLaunch.successful {
            
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
    }
}
