//
//  Coordinator.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import UIKit

protocol Coordinator {
    var parent: Coordinator? { get set }
    
    func start()
}
