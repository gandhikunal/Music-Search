//
//  TracksAppleMusic.swift
//  Music Search
//
//  Created by Kunal Gandhi on 19.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//


import Foundation

class TopLevelResponse: Decodable {
    var results: Results
    
    init(results: Results) {
        self.results = results
    }
}

class Results: Decodable {

    var songs: Songs
    init(songs: Songs) {
        self.songs = songs
    }
}

class Songs: Decodable {
    var data: [TracksWrapper]
    init(data: [TracksWrapper]) {
        self.data = data
    }
}

class TracksWrapper: Decodable {
    var attributes: [TracksAAPI]
    init(attributes: [TracksAAPI]) {
        self.attributes = attributes
    }
 
}

class PreviewUrl: Decodable {
    var url: String
    init(url: String) {
        self.url = url
    }
}

class TracksAAPI: Decodable {
    
    let name: String
    let url: PreviewUrl
    var dowloaded: Bool = false
    var identifier: Int = 0
    let artist: String
    
    enum AttributesKeys: String, CodingKey
    {
        case name = "name"
        case artist = "artistName"
        case previews
    }
    
    enum PreviewsKeys: String, CodingKey
    {
        case url = "url"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AttributesKeys.self)
        name = try values.decode(String.self, forKey: .name)
        artist = try values.decode(String.self, forKey: .artist)
        let preview = try values.nestedContainer(keyedBy: PreviewsKeys.self, forKey: .previews)
        url = try preview.decode(PreviewUrl.self, forKey: .url)
        
    }
    
    init(_ name: String, _ url: PreviewUrl, _ identifier: Int, _ artist: String) {
        self.name = name
        self.url = url
        self.identifier = identifier
        self.artist = artist
    }
}




