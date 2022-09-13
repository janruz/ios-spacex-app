//
//  AppCoordinator.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var parent: Coordinator?
    
    private var launchesCoordinator: LaunchesCoordinator?
    
    private var navigationController: UINavigationController
    
    init(navController : UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        if launchesCoordinator == nil {
            launchesCoordinator = LaunchesCoordinator(navController: navigationController, parent: self)
        }
        
        launchesCoordinator?.start()
    }
}
