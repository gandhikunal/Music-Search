//  NetworkApiManager.swift
//  Music Search
//
//  Created by Kunal Gandhi on 12.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//
import Foundation

enum ApiResponse <T: Decodable> {
    case sucess(T)
    case failure(String)
}
class NetworkApiManager {
    
    var defualtSession: URLSession?
    var downloadSession: URLSession?
    
    static let shared = NetworkApiManager()
    
    func queryTrack<T: Decodable>(term searchTerm: String, api choosenApi: ApiSelector?, completion: @escaping (ApiResponse<T>) -> ()) {
        let baseUrl = generateURLforAPI(api: choosenApi!, term: searchTerm)
            query(baseUrl) { (result: ApiResponse<SuperWrapper>) in
                switch result {
                case .sucess(let wrapper):
                    var tracks = wrapper.results
                    var startCount = 0
                    tracks.forEach { (track) in
                        track.identifier = startCount
                        startCount = startCount+1
                    }
                    completion(.sucess(tracks))
                    case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
        }
    }
    
    func query<T: Decodable>(_ url: URLRequest, completion: @escaping (ApiResponse<T>) -> ()){
        var errorDescription: String?
        let task = defualtSession?.dataTask(with: url) { data, response, error in
            
            if let error = error {
                errorDescription = "Error querying the API"+(error.localizedDescription)
                    completion(.failure(errorDescription!))
            }
            let response = response as! HTTPURLResponse
            if response.statusCode == 200 {
                if let data = data {
                    let r: ApiResponse<T> = self.getJsonSerializedData(data: data)
                        switch r {
                        case .sucess(let returnValue):
                            completion(.sucess(returnValue))
                        case .failure(let error):
                            completion(.failure(errorDescription!+error))
                            
                        }
                    
                }
            } else {

                    completion(.failure("Error Response Code"+String(describing: response.statusCode)))
            }
            
        }
        task?.resume()
    }
    
    private func getJsonSerializedData<U: Decodable>(data: Data) -> (ApiResponse<U>) {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(U.self, from: data)
            return ApiResponse.sucess(result)
        } catch let error as NSError {
            return ApiResponse.failure("JSON Decoding Error:"+error.localizedDescription)
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

