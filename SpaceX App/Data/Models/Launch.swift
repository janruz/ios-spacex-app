//
//  Launch.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import Foundation

struct Launch {
    let id: String
    let name: String
    let details: String?
    let successful: Bool?
    let dateUnix: Int
    let rocket: Rocket
    let launchpad: Launchpad
}

struct LaunchFromApi: Decodable {
    let id: String
    let name: String
    let details: String?
    let success: Bool?
    let date_unix: Int
    let rocket: RocketFromApi
    let launchpad: LaunchpadFromApi
}

extension Array where Element == LaunchFromApi {
    
    var asLaunches: [Launch] {
        map { source in
            Launch(
                id: source.id,
                name: source.name,
                details: source.details,
                successful: source.success,
                dateUnix: source.date_unix,
                rocket: source.rocket.asRocket,
                launchpad: source.launchpad.asLaunchpad
            )
        }
    }
}
