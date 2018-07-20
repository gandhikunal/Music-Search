//
//  TracksAppleMusic.swift
//  Music Search
//
//  Created by Kunal Gandhi on 19.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//


import Foundation

class TopLevelResponse: Decodable {
    var results: Result
    enum CodingKeys: String, CodingKey
    {
        case results = "results"
    }
    
    init(results: Result) {
        self.results = results
    }
}

class Result: Decodable {

    var songs: Song
    enum CodingKeys: String, CodingKey
    {
        case songs = "songs"
    }
    init(songs: Song) {
        self.songs = songs
    }
}

class Song: Decodable {
    var data: [Attributes]
    enum CodingKeys: String, CodingKey
    {
        case data = "data"
    }
    init(data: [Attributes]) {
        self.data = data
    }
}


class Attributes: Decodable {
    var attributes: TracksAAPI
    enum CodingKeys: String, CodingKey
    {
        case attributes = "attributes"
    }
    init(attributes: TracksAAPI) {
        self.attributes = attributes
    }
}

class TracksAAPI: Decodable {
    
    var name: String
    

    
    enum CodingKeys: String, CodingKey
    {
        case name = "name"
        

    }

    
 
    
    init(_ name: String) {
        self.name = name
//        self.identifier = identifier
//        self.artist = artist
    }
}




