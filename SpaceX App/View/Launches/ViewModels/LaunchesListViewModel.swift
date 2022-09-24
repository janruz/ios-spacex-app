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
    
    private var sortOrder = RocketLaunchSortOrder.dateDesc
    
    func fetchPastLaunches() {
        Task {
            let result = await RocketLaunchesRepository.shared.getPastLaunches()
            
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
    
    func order(by newSortOrder: RocketLaunchSortOrder) {
        sortOrder = newSortOrder
        publishRocketLaunches()
    }
    
    private func publishRocketLaunches() {
        let filtered = allRocketLaunches
            .filter {
                searchQuery.isEmpty ? true : $0.name.lowercased().contains(searchQuery.lowercased())
            }
            .sorted {
                switch self.sortOrder {
                case .dateDesc:
                    return $0.date > $1.date
                case .dateAsc:
                    return $0.date < $1.date
                }
            }
        
        rocketLaunches.accept(filtered)
    }
}

enum RocketLaunchSortOrder {
    case dateAsc
    case dateDesc
}
