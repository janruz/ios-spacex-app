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
    
    func fetchLaunches() {
        Task {
            let result = await RocketLaunchesRepository.shared.getLaunches()
            
            switch result {
            case .success(let launches):
                self.rocketLaunches.accept(launches)
            case .failure(_):
                break
            }
        }
    }
}
