//
//  RocketLaunchesRepository.swift
//  SpaceX App
//
//  Created by Jan Růžička on 12.09.2022.
//

import Foundation

struct RocketLaunchesRepository {
    
    static let shared = RocketLaunchesRepository()
    
    private init() {}
    
    func getLaunches() async -> Result<[RocketLaunch], Error> {
        return await RocketLaunchesWebService.shared.getLaunches()
    }
}
