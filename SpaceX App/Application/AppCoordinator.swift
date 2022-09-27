//
//  AppCoordinator.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import UIKit

class AppCoordinator: Coordinator {
    
    //MARK: - Properties
    
    var parent: Coordinator?
    
    private var launchesCoordinator: LaunchesCoordinator?
    
    private var navigationController: UINavigationController
    
    //MARK: - Lifecycle
    
    init(navController : UINavigationController) {
        self.navigationController = navController
    }
    
    //MARK: - Functionality
    
    func start() {
        if launchesCoordinator == nil {
            launchesCoordinator = LaunchesCoordinator(navController: navigationController, parent: self)
        }
        
        launchesCoordinator?.start()
    }
}
