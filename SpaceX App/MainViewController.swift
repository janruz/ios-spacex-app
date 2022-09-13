//
//  MainController.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import Foundation
import UIKit

class MainViewController: UINavigationController {
    
    //MARK: - Lifecycle
    
    init() {
        super.init(rootViewController: LaunchesViewController())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
    }
}
