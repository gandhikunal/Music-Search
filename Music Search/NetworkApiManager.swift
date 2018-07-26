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
        let baseUrl = generateURLforAPI(api: choosenApi!, term: searchTerm)
        if (choosenApi!.selectedApi.apiName == "itunes") {
                query(baseUrl) {     (result: ApiResponseGeneric<SuperWrapper>) in
                    switch result {
                    case .sucess(let wrapper):
                        var startCount = 0
                        let tracks = wrapper.results
                        tracks.forEach { (track) in
                            track.identifier = startCount
                            startCount = startCount+1
                        }
                        DispatchQueue.main.async {
                            completion(.sucess(tracks))
                        }
                        
                        case .failure(let error):
                        print(error)
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        
                    }
                }
        } else if (choosenApi!.selectedApi.apiName == "applemusic") {
                query(baseUrl) {     (result: ApiResponseGeneric<Result>) in
                switch result {
                case .sucess(let wrapper):
                    var startCount = 0
                    var tracksAll = [DisplayableTrack]()
                    let tracks = wrapper.results
                    tracks.forEach { (track) in
                        track.identifier = startCount
                        startCount = startCount+1
                    }
                    tracksAll = tracks
                    let choosenApiApple = ApiSelector.itunes
                    let baseUrl2 = self.generateURLforAPI(api: choosenApiApple, term: searchTerm)
                    self.query(baseUrl2) { (resultNew: ApiResponseGeneric<SuperWrapper>) in
                        switch resultNew {
                        case .sucess(let wrapperNew):
                            var startCount = 0
                            let tracksNew = wrapperNew.results
                            tracksNew.forEach { (track) in
                                track.identifier = startCount
                                startCount = startCount+1
                            }
                            print(tracksNew)
                            tracksAll.append(contentsOf: tracksNew)
                            print(tracksAll.count)
                            DispatchQueue.main.async {
                                completion(.sucess(tracksAll))
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    
                }
                }
        }
    }
    
    func query<T: Decodable>(_ url: URLRequest, completion: @escaping (ApiResponseGeneric<T>) -> ()){
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

