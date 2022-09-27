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
    let dateText: String
    
    let successIconName: String
    let successLabelText: String
    let successColor: UIColor
    
    let rocketText: NSAttributedString
    let launchpadText: NSAttributedString
    
    //MARK: - Lifecycle
    
    init(from launch: Launch) {
        name = launch.name
        details = launch.details ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        
        dateText = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(launch.dateUnix)))
        
        if let successful = launch.successful {
            
            if successful {
                successIconName = "checkmark.seal.fill"
                successLabelText = NSLocalizedString(Strings.Launches.successful, comment: "Successful rocket launch label")
                successColor = .systemGreen
                
            } else {
                successIconName = "clear.fill"
                successLabelText = NSLocalizedString(Strings.Launches.failed, comment: "Failed rocket launch label")
                successColor = .systemRed
            }
            
        } else {
            successIconName = "questionmark.circle.fill"
            successLabelText = NSLocalizedString(Strings.Launches.statusUnknown, comment: "Label for rocket launch with unknown status (success/failure)")
            successColor = .systemYellow
        }
        
        let rocketString = NSMutableAttributedString(
            string: NSLocalizedString(Strings.Rockets.label, comment: "Label for rocket information") + " ",
            attributes: [:]
        )
        let rocketNameString = NSAttributedString(
            string: launch.rocket.name,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
        )
        rocketString.append(rocketNameString)
        rocketText = rocketString
    
        let launchpadString = NSMutableAttributedString(
            string: NSLocalizedString(Strings.Launchpads.label, comment: "Label for launchpad information") + " ",
            attributes: [:]
        )
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
