//
//  TracksAppleMusic.swift
//  Music Search
//
//  Created by Kunal Gandhi on 19.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//


import Foundation

class Result: Decodable {
    var results: [TrackAppleMusic]
    
        init(results: [TrackAppleMusic]) {
            self.results = results
        }
    
        enum CodingKeys: String, CodingKey {
            case results
        }
    
        enum ResultsCodingKeys: String, CodingKey {
            case songs
        }
    
        enum SongsCodingKeys: String, CodingKey {
            case data
        }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(
                keyedBy: CodingKeys.self)
    
            let results = try container.nestedContainer(keyedBy: ResultsCodingKeys.self, forKey: .results)
            let songs = try results.nestedContainer(keyedBy: SongsCodingKeys.self, forKey: .songs)
            let data = try songs.decode([TrackAppleMusic].self, forKey: .data)
            self.init(results: data)
        }

}

class TrackAppleMusic: Decodable {
    var name: String
    var artistName: String
    var url: URL
    var identifier: Int = 0
    var trackId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }
    
    enum AttributeCodingKeys: String, CodingKey {
        case previews
        case name
        case artistName
    }
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let attribute = try container.nestedContainer(keyedBy: AttributeCodingKeys.self, forKey: .attributes)
        let name = try attribute.decode(String.self, forKey: .name)
        let artistName = try attribute.decode(String.self, forKey: .artistName)
        let url = try attribute.decode([Url].self, forKey: .previews)
        self.init(name: name,artistName: artistName, url: url, trackId: Int(id)!)
    }
    
    init(name: String, artistName: String, url: [Url], trackId: Int) {
        self.name = name
        self.artistName = artistName
        self.url = (url.first?.url)!
        self.trackId = trackId
    }
    
}

class Url: Decodable {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    enum CodingKeys: String, CodingKey {
        case url
    }
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let url = try container.decode(URL.self, forKey: .url)
        self.init(url: url)
    }
}

