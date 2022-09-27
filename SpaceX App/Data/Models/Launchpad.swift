//
//  Launchpad.swift
//  SpaceX App
//
//  Created by Jan Růžička on 25.09.2022.
//

import Foundation

struct Launchpad {
    let name: String
}

struct LaunchpadFromApi: Decodable {
    let name: String
}

extension LaunchpadFromApi {
    
    var asLaunchpad: Launchpad {
        Launchpad(name: self.name)
    }
}
