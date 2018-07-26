//  NetworkApiManager.swift
//  Music Search
//
//  Created by Kunal Gandhi on 12.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//
import Foundation

enum ApiResponseGeneric <T: Decodable> {
    case sucess(T)
    case failure(Error)
}

enum UIResponse <T> {
      case sucess(T)
      case failure(Error)
}


class NetworkApiManager {
    
    var defualtSession: URLSession?
    var downloadSession: URLSession?
    
    static let shared = NetworkApiManager()
    
    func queryTrack(term searchTerm: String, api choosenApi: ApiSelector?, completion: @escaping (UIResponse<[DisplayableTrack]>) -> ()) {
        var storedError: Error?
        var allTracks = [DisplayableTrack]()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        query(generateURLforAPI(api: ApiSelector.appleMusic, term: searchTerm)) {     (result: ApiResponseGeneric<Result>) in
            switch result {
            case .sucess(let wrapper):
                var startCount = 0
                let tracks = wrapper.results
                tracks.forEach { (track) in
                    track.identifier = startCount
                    startCount = startCount+1
                }
                allTracks.append(contentsOf: tracks)
            case .failure(let error):
               storedError = error
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        query(generateURLforAPI(api: ApiSelector.itunes, term: searchTerm)) {     (result: ApiResponseGeneric<SuperWrapper>) in
            switch result {
            case .sucess(let wrapper):
                var startCount = 0
                let tracks = wrapper.results
                tracks.forEach { (track) in
                    track.identifier = startCount
                    startCount = startCount+1
                }
                allTracks.append(contentsOf: tracks)
            case .failure(let error):
                storedError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            if storedError != nil {
               completion(.failure(storedError!))
            } else {
                completion(.sucess(allTracks))
            }
        }

    }
    
    private func query<T: Decodable>(_ url: URLRequest, completion: @escaping (ApiResponseGeneric<T>) -> ()){
//        var errorDescription: String?
        let task = defualtSession?.dataTask(with: url) { data, response, error in
            
            if let error = error {
//                errorDescription = "Error querying the API"+(error.localizedDescription)
                    completion(.failure(error))
            }
            let response = response as! HTTPURLResponse
            if response.statusCode == 200 {
                if let data = data {
                    let r: ApiResponseGeneric<T> = self.getJsonSerializedData(data: data)
                        switch r {
                        case .sucess(let returnValue):
                            completion(.sucess(returnValue))
                        case .failure(let error):
                            completion(.failure(error))
                            
                        }
                    
                }
            } else {

//                    completion(.failure("Error Response Code"+String(describing: response.statusCode)))
            }
            
        }
        task?.resume()
    }
    
    private func getJsonSerializedData<U: Decodable>(data: Data) -> (ApiResponseGeneric<U>) {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(U.self, from: data)
            return ApiResponseGeneric.sucess(result)
        } catch let error as NSError {
            return ApiResponseGeneric.failure(error)
        }
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
    
    private init() {
        self.defualtSession = URLSession(configuration: URLSessionConfiguration.default)
        //        self.downloadSession = URLSession(configuration: URLSessionConfiguration.background(withIdentifier:
        //            "background"), delegate: SearchViewController.self(), delegateQueue: nil)
    }
}



