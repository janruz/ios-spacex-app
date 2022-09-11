//
//  RocketLaunch.swift
//  SpaceX App
//
//  Created by Jan Růžička on 11.09.2022.
//

import Foundation

struct RocketLaunch: Decodable {
    let id: String
    let name: String
    let details: String?
    let success: Bool?
    let date_utc: String
}
