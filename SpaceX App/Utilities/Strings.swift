//
//  Strings.swift
//  SpaceX App
//
//  Created by Jan Růžička on 13.09.2022.
//

import Foundation
import SwiftUI

struct Strings {
    
    struct Launches {
        static let title = "launchesTitle"
        static let upcoming = "launchUpcoming"
        static let past = "launchPast"
        static let successful = "launchSuccessful"
        static let failed = "launchFailed"
        static let statusUnknown = "launchStatusUnknown"
        static let noLaunches = "noLaunches"
        static let noLaunchesMatchingSearchQuery = "noLaunchesMatchingSearchQuery"
        
        struct Sorting {
            static let title = "selectLaunchesSortOrder"
            static let dateAsc = "launchesSortOrderDateAsc"
            static let dateDesc = "launchesSortOrderDateDesc"
        }
    }
    
    struct Rockets {
        static let label = "rocketLabel"
    }
    
    struct Launchpads {
        static let label = "launchpadLabel"
    }
    
    struct Errors {
        static let defaultErrorMessage = "errorMessage"
    }
    
    static let cancel = "cancel"
    static let moreDetails = "moreDetails"
    static let order = "order"
}
