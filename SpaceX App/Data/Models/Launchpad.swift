//
//  Launchpad.swift
//  SpaceX App
//
//  Created by Jan Růžička on 25.09.2022.
//

import Foundation

struct Launchpad {
    let name: String
    let status: LaunchpadStatus
}

struct LaunchpadFromApi: Decodable {
    let name: String
    let status: LaunchpadStatus
}

enum LaunchpadStatus: String, Decodable {
    case active
    case inactive
    case unknown
    case retired
    case lost
    case underConstruction
}

extension LaunchpadFromApi {
    
    var asLaunchpad: Launchpad {
        Launchpad(name: self.name, status: self.status)
    }
}
