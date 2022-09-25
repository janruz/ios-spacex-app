//
//  LaunchesRepository.swift
//  SpaceX App
//
//  Created by Jan Růžička on 12.09.2022.
//

import Foundation

struct LaunchesRepository {
    
    static let shared = LaunchesRepository()
    
    private init() {}
    
    func getPastLaunches() async -> Result<[Launch], Error> {
        return await LaunchesWebService.shared.getPastLaunches().map { $0.asLaunches }
    }
}
