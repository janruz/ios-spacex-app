//
//  RocketLaunchesWebService.swift
//  SpaceX App
//
//  Created by Jan Růžička on 12.09.2022.
//

import Foundation
import Alamofire

struct RocketLaunchesWebService {
    
    static let shared = RocketLaunchesWebService()
    
    private init() {}
    
    func getLaunches() async -> Result<[RocketLaunch], Error> {
        let response = await AF.request("https://api.spacexdata.com/v5/launches", method: .get).serializingDecodable([RocketLaunch].self).response
        
        return response.result.mapError { afError in
            return afError as Error
        }
    }
}
