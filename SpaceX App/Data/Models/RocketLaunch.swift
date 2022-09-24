//
//  RocketLaunch.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import Foundation

struct RocketLaunch {
    let id: String
    let name: String
    let details: String?
    let successful: Bool?
    let upcoming: Bool
    let date: String
    let rocket: Rocket
    let launchpad: Launchpad
}

struct RocketLaunchFromApi: Decodable {
    let id: String
    let name: String
    let details: String?
    let success: Bool?
    let upcoming: Bool
    let date_utc: String
    let rocket: RocketFromApi
    let launchpad: LaunchpadFromApi
}

extension Array where Element == RocketLaunchFromApi {
    
    var asRocketLaunches: [RocketLaunch] {
        map { source in
            RocketLaunch(
                id: source.id,
                name: source.name,
                details: source.details,
                successful: source.success,
                upcoming: source.upcoming,
                date: source.date_utc,
                rocket: source.rocket.asRocket,
                launchpad: source.launchpad.asLaunchpad
            )
        }
    }
}
