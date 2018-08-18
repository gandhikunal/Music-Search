    
//  NetworkApiManager.swift
//  Music Search
//
//  Created by Kunal Gandhi on 12.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//
import Foundation

enum UIResponse <T> {
      case sucess(T)
      case failure(Error)
}

class NetworkApiManager {
    
  
    func queryTrack(term searchTerm: String, api choosenApi: ApiSelector?, completion: @escaping (UIResponse<[DisplayableTrack]>) -> ()) {
        var storedError: Error?
        var allTracks = [DisplayableTrack]()
        let dispatchGroup = DispatchGroup()
        if let uncachedTracks = cache.lookUp(key: searchTerm) {
            completion(.sucess(uncachedTracks))
        } else {
            dispatchGroup.enter()
            webService.query(generateURLforAPI(api: ApiSelector.appleMusic, term: searchTerm)) {     (result: ApiResponseGeneric<Result>) in
                switch result {
                case .sucess(let wrapper):
                    var startCount = 0
                    let tracks = wrapper.results
                    tracks.forEach { (track) in
                        track.identifier = startCount
                        startCount = startCount+1
                    }
                    allTracks.append(contentsOf: TrackAppleMusic.convertToDisplayableType(tracks: tracks))

                case .failure(let error):
                    storedError = error
                }
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            webService.query(generateURLforAPI(api: ApiSelector.itunes, term: searchTerm)) {     (result: ApiResponseGeneric<SuperWrapper>) in
                switch result {
                case .sucess(let wrapper):
                    var startCount = 0
                    let tracks = wrapper.results
                    tracks.forEach { (track) in
                        track.identifier = startCount
                        startCount = startCount+1
                    }

                    allTracks.append(contentsOf: TracksItunes.convertToDisplayableType(tracks: tracks))
                case .failure(let error):
                    storedError = error
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                if storedError != nil {
                    completion(.failure(storedError!))
                } else {
                    let normalizedTracks = self.normailzeData(allTracks: allTracks)
                    cache.add(key: searchTerm, normalizedTracks: normalizedTracks)
                    completion(.sucess(normalizedTracks))
                }
            }
        }
        

    }

    
    private func normailzeData (allTracks tracks: [DisplayableTrack]) -> ([DisplayableTrack]) {
        var isSeen: [Int] = []
        let uniqueSongList = tracks.filter { (tracksClosure) -> Bool in
            if (isSeen.contains(tracksClosure.trackId)) {
                return false
            } else {
                isSeen.append(tracksClosure.trackId)
                return true
            }
        }
        return uniqueSongList
    }
    
    private func generateURLforAPI(api choosenApi: ApiSelector?, term searchTerm: String) -> URLRequest {
        var urlComponents = URLComponents(string: (choosenApi?.selectedApi.baseUrl)!)
        var request = URLRequest(url: (urlComponents?.url)!)
        if choosenApi?.selectedApi.apiName == "applemusic" {
            var tokenString = choosenApi?.selectedApi.userToken!
            urlComponents?.query = "term=\(searchTerm)&include=tracks"
            request = URLRequest(url: (urlComponents?.url!)!)
            tokenString = "Bearer " + tokenString!
            request.setValue(tokenString, forHTTPHeaderField: "Authorization")
            print(request)
        } else if choosenApi?.selectedApi.apiName == "itunes" {
            urlComponents?.query = "media=music&entity=song&term=\(searchTerm)"
            request = URLRequest(url: (urlComponents?.url!)!)
            
        }
        return request
    }
    
    
}



