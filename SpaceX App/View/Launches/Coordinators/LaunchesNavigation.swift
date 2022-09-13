//
//  LaunchesNavigation.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import Foundation

protocol LaunchesNavigation {
    func goToLaunchesList()
    func goToLaunchDetail(of rocketLaunch: RocketLaunch)
}
