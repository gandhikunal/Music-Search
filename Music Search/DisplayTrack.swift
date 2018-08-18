//
//  DisplayTrack.swift
//  Music Search
//
//  Created by Kunal Gandhi on 23.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import Foundation

class DisplayableTrack: Codable {
    var signerName: String
    var songName: String
    var id: Int
    var trackId: Int
    var trackUrl: URL
    
    init(signerName: String, songName: String, id: Int, trackId: Int, trackUrl: URL) {
        self.signerName = signerName
        self.songName = songName
        self.id = id
        self.trackId = trackId
        self.trackUrl = trackUrl
    }
}


extension TracksItunes {
    static func convertToDisplayableType(tracks: [TracksItunes]) -> [DisplayableTrack] {
        var displayTrack = [DisplayableTrack]()
        tracks.forEach { (track) in
            displayTrack.append(DisplayableTrack(signerName: track.artist, songName: track.name, id: track.identifier, trackId: track.trackId, trackUrl: track.url))
        }
        return displayTrack
    }
}

extension TrackAppleMusic {
    static func convertToDisplayableType(tracks: [TrackAppleMusic]) -> [DisplayableTrack] {
        var displayTrack = [DisplayableTrack]()
        tracks.forEach { (track) in
            displayTrack.append(DisplayableTrack(signerName: track.artistName, songName: track.name, id: track.identifier, trackId: track.trackId, trackUrl: track.url))
        }
        return displayTrack
    }
}
