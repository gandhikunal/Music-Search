//
//  DisplayTrack.swift
//  Music Search
//
//  Created by Kunal Gandhi on 23.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import Foundation

protocol DisplayableTrack: Decodable {
    var signerName: String {get}
    var songName: String {get}
    var id: Int {get}
    var trackurl: URL {get}
}


extension TracksItunes: DisplayableTrack {
    var signerName: String {
        return self.artist
    }
    
    var songName: String {
        return self.name
    }
    
    var id: Int {
        return self.identifier
    }
    var trackurl: URL {
        return self.url
    }
    
}

extension TrackAppleMusic: DisplayableTrack {
    var signerName: String {
        return self.artistName
    }
    
    var songName: String {
        return self.name
    }
    
    var id: Int {
        return self.identifier
    }
    var trackurl: URL {
        return self.url
    }
}
