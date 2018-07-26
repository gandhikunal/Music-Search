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
            return ApiConstants(baseUrl: "https://api.music.apple.com/v1/catalog/us/search", apiName: "applemusic", userToken: "eyJhbGciOiImtpZCI6IlQ2Rk5SWjI3V1oifQ.eyJpc3MiOiI1MlRaQlJCVFlOIiwiaWF0IjoxNTMyNjMzMzI4LCJleHAiOjE1MzI2NzY1Mjh9.Cv7e1wM5qWpytIsS6qUbDzsh9m6A0ZhffL5bRC2t8Ue9KuA6q8IU541qIaQ0I88BSjxE7KxJvhs74YaWbAOhpw")
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


