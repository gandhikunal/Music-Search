//
//  Tacks.swift
//  Music Search
//
//  Created by Kunal Gandhi on 12.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import Foundation

class SuperWrapper: Decodable {
    var resultCount: Int
    var results: [TracksItunes]
    
    init(resultCount: Int, results: [TracksItunes]) {
        self.resultCount = resultCount
        self.results = results
    }
}

class TracksItunes: Decodable {
    
    let name: String
    let url: URL
    var dowloaded: Bool = false
    var identifier: Int = 0
    let artist: String
    
    enum CodingKeys: String, CodingKey
    {
    case name = "trackName"
    case artist = "artistName"
    case url = "previewUrl"
    
    }
    
    init(_ name:String, _ url:URL, _ identifier:Int, _ artist: String) {
        self.name = name
        self.url = url
        self.identifier = identifier
        self.artist = artist
    }
}



