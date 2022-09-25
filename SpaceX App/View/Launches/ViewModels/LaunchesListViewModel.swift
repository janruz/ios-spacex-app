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
    
    let launches = BehaviorRelay<[Launch]>(value: [])
    
    let isLoading = BehaviorRelay<Bool>(value: true)
    
    let isError = BehaviorRelay<Bool>(value: false)
    
    private var allLaunches = [Launch]()
    
    private var searchQuery = ""
    
    let sortOrder = BehaviorRelay<LaunchSortOrder>(value: LaunchSortOrder.dateDesc)
    
    private let defaults = UserDefaults.standard
    
    private static let sortOrderKey = "launchesSortOrder"
    
    private let disposeBag = DisposeBag()
    
    private let repository: LaunchesRepository
    
    init(repository: LaunchesRepository) {
        self.repository = repository
        
        if let savedSortOrder = LaunchSortOrder(rawValue: defaults.integer(forKey: LaunchesListViewModel.sortOrderKey)) {
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
            
            let result = await repository.getPastLaunches()
            
            isLoading.accept(false)
            
            switch result {
            case .success(let launches):
                self.isError.accept(false)
                self.allLaunches = launches
                self.publishLaunches()
            case .failure(_):
                self.isError.accept(true)
                break
            }
        }
    }
    
    func searchLaunches(with query: String) {
        searchQuery = query
        publishLaunches()
    }
    
    func order(by newSortOrder: LaunchSortOrder) {
        sortOrder.accept(newSortOrder)
        publishLaunches()
    }
    
    private func publishLaunches() {
        let filtered = allLaunches
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
        
        launches.accept(filtered)
    }
}

enum LaunchSortOrder: Int {
    case dateDesc
    case dateAsc
    
    var title: String {
        switch self {
        case .dateAsc: return "date asc"
        case .dateDesc: return "date desc"
        }
    }
}
