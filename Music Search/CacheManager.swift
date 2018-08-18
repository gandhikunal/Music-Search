//
//  CacheManager.swift
//  Music Search
//
//  Created by Kunal Gandhi on 28.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import Foundation

class MemoryCache {
    typealias cacheTracksDiskType = [Int:DisplayableTrack]
    typealias cacheIdsDiskType = [String:[Int]]
    var cacheIds = NSCache<NSString,NSArray>()
    private var cacheTracks = NSCache<NSNumber,DisplayableTrack>()
    private var cacheKeys = Set<String>()
    private var cacheTracksDisk = cacheTracksDiskType()
    private var cacheIdsDisk = cacheIdsDiskType()
    
    
    func normailzeCacheData (normalizedTracks tracks: [DisplayableTrack]) {
        var isSeen: [Int] = []
        
        tracks.forEach({ (track) in
            isSeen.append(track.trackId)
            if let _ = cacheTracks.object(forKey: NSNumber(integerLiteral: track.trackId)) {
                return
            } else {
                cacheTracks.setObject(track, forKey: NSNumber(integerLiteral: track.trackId))
                cacheTracksDisk[track.trackId] = track
            }
        })
    
    }
    
    func add (key: String, normalizedTracks tracks: [DisplayableTrack]) {
        var value = [Int]()
        tracks.forEach { (track) in
            value.append(track.trackId)
        }
        cacheIds.setObject(NSArray(array: value), forKey: NSString(string: key))
        cacheIdsDisk[key] = value
        if !(cacheKeys.contains(key)) {
            cacheKeys.insert(key)
        }
        normailzeCacheData(normalizedTracks: tracks)
        let result = writeToDisk()
        if result {
            print("Sucess")
        } else {
            print("Failure")
        }
    }

    func remove(key: String) {
        let trackIds = cacheIds.object(forKey: NSString(string: key)) as! [Int]
        var removableTrackIdsSet = Set(trackIds.map { $0 })
        cacheIds.removeObject(forKey: NSString(string: key))
        cacheKeys.remove(key)
        var commonIdsSet = Set<Int>()
        cacheKeys.forEach { (key) in
            let tempTrackIds = cacheIds.object(forKey: NSString(string:key)) as! [Int]
            let cachedIdsSet = Set(tempTrackIds.map { $0 })
            commonIdsSet.formUnion(cachedIdsSet.intersection(removableTrackIdsSet))
        }
        removableTrackIdsSet.subtract(commonIdsSet)
        removableTrackIdsSet.forEach { (trackId) in
            cacheTracks.removeObject(forKey: NSNumber(integerLiteral: trackId))
        }
    }

    func lookUp(key: String) -> [DisplayableTrack]? {
        if let unCachedIds = cacheIds.object(forKey: NSString(string: key)) as? [Int] {
            var unCachedTracks = [DisplayableTrack]()
            unCachedIds.forEach { (index) in
            if let trackLookUp = cacheTracks.object(forKey: NSNumber(integerLiteral: index)) {
                unCachedTracks.append(trackLookUp)
            }
            }
            return unCachedTracks
        }
        return nil
    }
    
    func createFolder(folderName: String) -> URL? {
        
        let fileHandler = FileManager.default
        do {
            let cacheDirectoryUrl = try fileHandler.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let folderUrl = cacheDirectoryUrl.appendingPathComponent(folderName, isDirectory: true)
            if !fileHandler.fileExists(atPath: folderUrl.path) {
                try fileHandler.createDirectory(atPath: folderUrl.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            }
            return folderUrl
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    
    func writeToDisk() -> Bool {
        var jsonTracksData: Data?
        var jsonKeyData: Data?
        
        if let writeDirectoryUrl = createFolder(folderName:"cacheDirectory") {
            do {
                let jsonTrackDataUrl = writeDirectoryUrl.appendingPathComponent("cacheTrackData.json")
                let jsonIdDataUrl = writeDirectoryUrl.appendingPathComponent("cacheIdData.json")
                let encoder = JSONEncoder()
                jsonKeyData = try encoder.encode(cacheIdsDisk)
                jsonTracksData = try encoder.encode(cacheTracksDisk)
                try jsonTracksData?.write(to: jsonTrackDataUrl)
                try jsonKeyData?.write(to: jsonIdDataUrl)
            } catch {
                print(error.localizedDescription)
            }
            
        } else {
            return false
        }
        return true
    }
    
    func readFromDisk() -> Bool {
        if let writeDirectoryUrl = createFolder(folderName:"cacheDirectory") {
            let cacheIdFilePath = writeDirectoryUrl.appendingPathComponent("cacheIdData.json")
            let cacheTrackFilePath = writeDirectoryUrl.appendingPathComponent("cacheTrackData.json")
            clearCahce()
            let cacheIdData = try? Data(contentsOf: cacheIdFilePath)
            let cacheTrackData = try? Data(contentsOf: cacheTrackFilePath)
            let decoder = JSONDecoder()
            cacheIdsDisk = try! decoder.decode(cacheIdsDiskType.self, from: cacheIdData!)
            cacheTracksDisk = try! decoder.decode(cacheTracksDiskType.self, from: cacheTrackData!)
            cacheIdsDisk.forEach { (key,id) in
                var tracks = [DisplayableTrack]()
                id.forEach({ (id) in
                    tracks.append(cacheTracksDisk[id]!)
                })
               add(key: key, normalizedTracks: tracks)
            }
        } else {
            return false
        }
        return true
    }
    
    func clearCahce() {
        cacheIds.removeAllObjects()
        cacheTracks.removeAllObjects()
        cacheKeys.removeAll()
    }
}
