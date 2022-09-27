//
//  LaunchesListViewModel.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import Foundation
import Combine

class LaunchesListViewModel {
    
    @Published private(set) var launches = [Launch]()
    
    @Published private(set) var isLoading = false
    
    @Published private(set) var isRefreshing = false
    
    @Published private(set) var isError = false
    
    @Published private(set) var sortOrder = LaunchSortOrder.dateDesc
    
    private(set) var allLaunches = [Launch]()
    
    private var searchQuery = ""
    
    private let defaults = UserDefaults.standard
    
    private static let sortOrderKey = "launchesSortOrder"
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let repository: LaunchesRepository
    
    init(repository: LaunchesRepository) {
        self.repository = repository
        
        if let savedSortOrder = LaunchSortOrder(rawValue: defaults.integer(forKey: LaunchesListViewModel.sortOrderKey)) {
            sortOrder = savedSortOrder
        }
        
        $sortOrder
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { order in
                self.defaults.set(order.rawValue, forKey: LaunchesListViewModel.sortOrderKey)
            }
            .store(in: &subscriptions)
    }
    
    func fetchLaunches() {
        guard !isLoading else { return }
        
        Task {
            isError = false
            isLoading = true
            
            let result = await repository.getPastLaunches()
            
            isLoading = false
            
            handleLaunchesResult(result)
        }
    }
    
    func refreshLaunches() {
        guard !isRefreshing && !isLoading else { return }
        
        Task {
            isError = false
            isRefreshing = true
            
            let result = await repository.getPastLaunches()
            
            isRefreshing = false
            
            handleLaunchesResult(result)
        }
    }
    
    func searchLaunches(with query: String) {
        searchQuery = query
        publishLaunches()
    }
    
    func order(by newSortOrder: LaunchSortOrder) {
        sortOrder = newSortOrder
        publishLaunches()
    }
    
    private func handleLaunchesResult(_ result: Result<[Launch], Error>) {
        switch result {
        case .success(let launches):
            self.isError = false
            self.allLaunches = launches
            self.publishLaunches()
        case .failure(_):
            self.isError = true
            break
        }
    }
    
    private func publishLaunches() {
        
        launches = allLaunches
            .filter { launch in
                searchQuery.isEmpty ? true : launch.name.lowercased().contains(searchQuery.lowercased())
            }
            .sorted { (launch0: Launch, launch1: Launch) in
                switch self.sortOrder {
                case .dateDesc:
                    return Date(timeIntervalSince1970: TimeInterval(launch0.dateUnix)) > Date(timeIntervalSince1970: TimeInterval(launch1.dateUnix))
                case .dateAsc:
                    return Date(timeIntervalSince1970: TimeInterval(launch0.dateUnix)) < Date(timeIntervalSince1970: TimeInterval(launch1.dateUnix))
                }
            }
    }
}

enum LaunchSortOrder: Int {
    case dateDesc
    case dateAsc
    
    var title: String {
        switch self {
        case .dateAsc: return NSLocalizedString(Strings.Launches.Sorting.dateAsc, comment: "Label for date ascending")
        case .dateDesc: return NSLocalizedString(Strings.Launches.Sorting.dateDesc, comment: "Label for date descending")
        }
    }
}
