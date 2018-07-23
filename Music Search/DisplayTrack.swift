//
//  DisplayTrack.swift
//  Music Search
//
//  Created by Kunal Gandhi on 23.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import Foundation

protocol DisplayableTrack {
    var artistName: String {get}
    var songName: String {get}
    var ientifier: Int {get}
    var url: URL {get}
}


extension TracksItunes: DisplayableTrack {
    var artistName: String {
        return self.artist
    }
    
    var songName: String {
        return self.name
    }
    
    var ientifier: Int {
        return self.identifier
    }
    
    
}
