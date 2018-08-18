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
            return ApiConstants(baseUrl: "https://api.music.apple.com/v1/catalog/us/search", apiName: "applemusic", userToken: "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik5ENEJNTDczN0sifQ.eyJpc3MiOiI1MlRaQlJCVFlOIiwiaWF0IjoxNTM0NTIxNjg3LCJleHAiOjE1NDc0ODUyODd9.g7TRHtXhWg8R6KQt0QwGlt0VkAODXoq-yn4voGbnMZoQIbLJl2TnWryl8C983glkUrvtNGcdFlSH0JPgqPVwuA")
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


