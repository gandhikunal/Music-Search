//
//  ApiConstants.swift
//  Music Search
//
//  Created by Kunal Gandhi on 16.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import Foundation

enum ApiSelector {
    
    case itunes
    case appleMusic
    
    var selectedApi: ApiConstants {
        switch self {
        case .itunes:
            return ApiConstants(baseUrl: "https://itunes.apple.com/search", apiName: "itunes", userToken: nil)
        case .appleMusic:
            return ApiConstants(baseUrl: "https://api.music.apple.com/v1/catalog/us/search", apiName: "applemusic", userToken: "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlQ2Rk5SWjI3V1oifQ.eyJpc3MiOiI1MlRaQlJCVFlOIiwiaWF0IjoxNTMyMDExOTg3LCJleHAiOjE1MzIwNTUxODd9.KMzhvmZIgs-avK_NZunTHVwSWaVBKASdzbdCwQD2Z8MKvQgJjJKMkW4ubkxkGe9IiGhdgkBY1dd_O6658Bk76w")
        }
    }
    
    struct ApiConstants {
        let baseUrl: String
        let userToken: String?
        let apiName: String
        
        fileprivate init(baseUrl: String, apiName: String, userToken: String? = nil) {
           self.baseUrl = baseUrl
           self.userToken = userToken
            self.apiName = apiName
            
        }
    }
}

