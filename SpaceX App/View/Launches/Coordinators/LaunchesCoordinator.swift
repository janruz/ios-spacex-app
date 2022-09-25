//
//  LaunchesCoordinator.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import UIKit

class LaunchesCoordinator: Coordinator, LaunchesNavigation {
    
    var parent: Coordinator?
    
    private var navigationController: UINavigationController
    
    init(navController : UINavigationController, parent: Coordinator?) {
        self.navigationController = navController
        self.parent = parent
    }
    
    func start() {
        goToLaunchesList()
    }
    
    func goToLaunchesList() {
        let launchesListVC = LaunchesListViewController(navigation: self, viewModel: LaunchesListViewModel())
        
        navigationController.pushViewController(launchesListVC, animated: true)
    }
    
    func goToLaunchDetail(of launch: Launch) {
        let launchDetailVC = LaunchDetailViewController(for: launch)
        
        navigationController.pushViewController(launchDetailVC, animated: true)
    }
}
