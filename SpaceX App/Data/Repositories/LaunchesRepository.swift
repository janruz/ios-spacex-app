//
//  LaunchesRepository.swift
//  SpaceX App
//
//  Created by Jan Růžička on 12.09.2022.
//

import Foundation

protocol LaunchesRepository {
    func getPastLaunches() async -> Result<[Launch], Error>
}

struct LaunchesRepositoryImpl: LaunchesRepository {
    
    static let shared = LaunchesRepositoryImpl(launchesWebService: LaunchesWebServiceImpl.shared)
    
    private let launchesWebService: LaunchesWebService
    
    init(launchesWebService: LaunchesWebService) {
        self.launchesWebService = launchesWebService
    }
    
    func getPastLaunches() async -> Result<[Launch], Error> {
        return await launchesWebService.getPastLaunches().map { $0.asLaunches }
    }
}
