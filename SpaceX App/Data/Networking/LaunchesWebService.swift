//
//  LaunchesWebService.swift
//  SpaceX App
//
//  Created by Jan Růžička on 12.09.2022.
//

import Foundation
import Alamofire

protocol LaunchesWebService {
    func getPastLaunches() async -> Result<[LaunchFromApi], Error>
}

struct LaunchesWebServiceImpl: LaunchesWebService {
    
    static let shared = LaunchesWebServiceImpl()
    
    func getPastLaunches() async -> Result<[LaunchFromApi], Error> {
        let parameters = GetLaunchesParameters(upcoming: false, populate: ["rocket", "launchpad"], pagination: false)
        
        let response = await AF.request(
            "\(Constants.baseApiUrl)/v4/launches/query",
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default
        )
            .serializingDecodable(FetchLaunchesResponse.self)
            .response
        
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
        
        init(upcoming: Bool, populate: [String], pagination: Bool) {
            query = GetLaunchesParameters.Query(upcoming: upcoming)
            options = GetLaunchesParameters.Options(populate: populate, pagination: pagination)
        }
        
        struct Query: Encodable {
            let upcoming: Bool
        }
        
        struct Options: Encodable {
            let populate: [String]
            let pagination: Bool
        }
    }
}
