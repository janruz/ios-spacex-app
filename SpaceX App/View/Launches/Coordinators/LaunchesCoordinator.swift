//
//  LaunchesCoordinator.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import UIKit

class LaunchesCoordinator: Coordinator, LaunchesNavigation {
    
    //MARK: - Properties
    
    var parent: Coordinator?
    
    private var navigationController: UINavigationController
    
    //MARK: - Lifecycle
    
    init(navController : UINavigationController, parent: Coordinator?) {
        self.navigationController = navController
        self.parent = parent
    }
    
    //MARK: - Functionality
    
    func start() {
        goToLaunchesList()
    }
    
    func goToLaunchesList() {
        let launchesListVC = LaunchesListViewController(
            navigation: self,
            viewModel: LaunchesListViewModel(
                repository: LaunchesRepositoryImpl.shared,
                prefs: UserDefaultsPreferencesStorage.shared
            )
        )
        
        navigationController.pushViewController(launchesListVC, animated: true)
    }
    
    func goToLaunchDetail(of launch: Launch) {
        let launchDetailVC = LaunchDetailViewController(for: launch)
        
        navigationController.pushViewController(launchDetailVC, animated: true)
    }
}
