//
//  LaunchesListViewModel.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import Foundation
import RxSwift
import RxRelay

class LaunchesListViewModel {
    
    let rocketLaunches = BehaviorRelay<[RocketLaunch]>(value: [])
    
    private var allRocketLaunches = [RocketLaunch]()
    
    private var searchQuery = ""
    
    func fetchLaunches() {
        Task {
            let result = await RocketLaunchesRepository.shared.getLaunches()
            
            switch result {
            case .success(let launches):
                self.allRocketLaunches = launches
                self.publishRocketLaunches()
            case .failure(_):
                break
            }
        }
    }
    
    func searchLaunches(with query: String) {
        searchQuery = query
        publishRocketLaunches()
    }
    
    private func publishRocketLaunches() {
        let filtered = searchQuery.isEmpty ? allRocketLaunches : allRocketLaunches.filter { $0.name.contains(searchQuery) }
        rocketLaunches.accept(filtered)
    }
}
