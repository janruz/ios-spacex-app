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
    
    //MARK: - Properties
    
    static let shared = LaunchesRepositoryImpl(launchesWebService: LaunchesWebServiceImpl.shared)
    
    private let launchesWebService: LaunchesWebService
    
    //MARK: - Lifecycle
    
    init(launchesWebService: LaunchesWebService) {
        self.launchesWebService = launchesWebService
    }
    
    //MARK: - Functionality
    
    func getPastLaunches() async -> Result<[Launch], Error> {
        return await launchesWebService.getPastLaunches().map { $0.asLaunches }
    }
}
