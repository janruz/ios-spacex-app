//
//  LaunchesWebService.swift
//  SpaceX App
//
//  Created by Jan Růžička on 12.09.2022.
//

import Foundation
import Alamofire

struct LaunchesWebService {
    
    static let shared = LaunchesWebService()
    
    private init() {}
    
    func getPastLaunches() async -> Result<[LaunchFromApi], Error> {
        let parameters = GetLaunchesParameters(
            query: GetLaunchesParameters.Query(upcoming: false),
            options: GetLaunchesParameters.Options(populate: ["rocket", "launchpad"], pagination: false)
        )
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
        let docs: [LaunchFromApi]
    }
    
    struct GetLaunchesParameters: Encodable {
        let query: Query
        let options: Options
        
        struct Query: Encodable {
            let upcoming: Bool
        }
        
        struct Options: Encodable {
            let populate: [String]
            let pagination: Bool
        }
    }
    
    
}
