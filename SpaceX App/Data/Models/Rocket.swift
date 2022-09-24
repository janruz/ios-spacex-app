//
//  Rocket.swift
//  SpaceX App
//
//  Created by Jan Růžička on 25.09.2022.
//

import Foundation

struct Rocket {
    let name: String
    let active: Bool
}

struct RocketFromApi: Decodable {
    let name: String
    let active: Bool
}

extension RocketFromApi {
    
    var asRocket: Rocket {
        Rocket(name: self.name, active: self.active)
    }
}
