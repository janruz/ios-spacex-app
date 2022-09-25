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
    
    let isLoading = BehaviorRelay<Bool>(value: true)
    
    private var allRocketLaunches = [RocketLaunch]()
    
    private var searchQuery = ""
    
    let sortOrder = BehaviorRelay<RocketLaunchSortOrder>(value: RocketLaunchSortOrder.dateDesc)
    
    private let defaults = UserDefaults.standard
    
    private static let sortOrderKey = "launchesSortOrder"
    
    private let disposeBag = DisposeBag()
    
    init() {
        if let savedSortOrder = RocketLaunchSortOrder(rawValue: defaults.integer(forKey: LaunchesListViewModel.sortOrderKey)) {
            sortOrder.accept(savedSortOrder)
        }
        
        sortOrder
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] order in
                self.defaults.set(order.rawValue, forKey: LaunchesListViewModel.sortOrderKey)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchPastLaunches() {
        Task {
            isLoading.accept(true)
            
            let result = await RocketLaunchesRepository.shared.getPastLaunches()
            
            isLoading.accept(false)
            
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
        sortOrder.accept(newSortOrder)
        publishRocketLaunches()
    }
    
    private func publishRocketLaunches() {
        let filtered = allRocketLaunches
            .filter {
                searchQuery.isEmpty ? true : $0.name.lowercased().contains(searchQuery.lowercased())
            }
            .sorted {
                switch self.sortOrder.value {
                case .dateDesc:
                    return $0.date > $1.date
                case .dateAsc:
                    return $0.date < $1.date
                }
            }
        
        rocketLaunches.accept(filtered)
    }
}

enum RocketLaunchSortOrder: Int {
    case dateDesc
    case dateAsc
    
    var title: String {
        switch self {
        case .dateAsc: return "date asc"
        case .dateDesc: return "date desc"
        }
    }
}
