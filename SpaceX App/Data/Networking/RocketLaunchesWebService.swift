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
    
    func getLaunches() async -> Result<[RocketLaunchFromApi], Error> {
        let parameters = [
            "options": FetchLaunchesOptions(populate: ["rocket", "launchpad"])
        ]
        let response = await AF.request("https://api.spacexdata.com/v5/launches/query", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).serializingDecodable(FetchLaunchesResponse.self).response
        
        if let error = response.error {
            print(error)
        }
        
        return response.result.mapError { afError in
            return afError as Error
        }.map { response in
            return response.docs
        }
    }
    
    private struct FetchLaunchesResponse: Decodable {
        let docs: [RocketLaunchFromApi]
    }
    
    private struct FetchLaunchesOptions: Encodable {
        let populate: [String]
    }
}
