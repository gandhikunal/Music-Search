//
//  QueryService.swift
//  Music Search
//
//  Created by Kunal Gandhi on 12.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import Foundation

class NetworkApiManager {
    
    var defualtSession: URLSession?
    var downloadSession: URLSession?
    var queryTask = URLSessionTask()
    var errorMessage: String?
//    var downloadTask = URLSessionDownloadTask()
    typealias resultProccesor = ([Tracks],String?)->()
    
    static let shared = NetworkApiManager()

    func query (term searchTerm: String, api choosenApi: ApiSelector, completion: @escaping resultProccesor){
        
        let baseUrl = generateURLforAPI(api: choosenApi, term: searchTerm)
        var tracks = [Tracks]()
        let task = defualtSession?.dataTask(with: baseUrl) { data, response, error in

            if error != nil {
                self.errorMessage = "Querying Error:"+(error?.localizedDescription)!
                print(error.debugDescription)
            }
            let response = response as! HTTPURLResponse
            if response.statusCode == 200 {
                print("recieved some data")
                if let data = data {
                    tracks = self.getJsonSerializedData(data: data, apiName: choosenApi.selectedApi.apiName)
               
                }
            }
            DispatchQueue.main.async {
                print(tracks)
                completion(tracks,self.errorMessage)
            }
            
        }
        task?.resume()
    }
    
    private func getJsonSerializedData(data: Data, apiName: String) -> ([Tracks]) {
        let decoder = JSONDecoder()
        var tracks = [Tracks]()
        do {
            if apiName == "itunes" {
                let result = try decoder.decode(SuperWrapper.self, from: data)
                tracks = result.results
            } else {
                let result = try decoder.decode(TopLevelResponse.self, from: data)
               print(result)
            }
            
            var startCount = 0
            tracks.forEach { (track) in
                track.identifier = startCount
                 startCount = startCount+1
            }
           
        } catch let error as NSError {
            print(error)
            errorMessage! += "Json Serialization Error: \(error.localizedDescription)"
        }
        return tracks
    }
    
    private func generateURLforAPI(api choosenApi: ApiSelector, term searchTerm: String) -> URLRequest {
        var urlComponents = URLComponents(string: choosenApi.selectedApi.baseUrl)
        var request = URLRequest(url: (urlComponents?.url)!)
        if choosenApi.selectedApi.apiName == "applemusic" {
             var tokenString = choosenApi.selectedApi.userToken!
            urlComponents?.query = "term=\(searchTerm)&include=tracks"
                request = URLRequest(url: (urlComponents?.url!)!)
                tokenString = "Bearer " + tokenString
                request.setValue(tokenString, forHTTPHeaderField: "Authorization")
        } else if choosenApi.selectedApi.apiName == "itunes" {
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
struct AnyCodingKey : CodingKey {
    
    var stringValue: String
    var intValue: Int?
    
    init(_ base: CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}

private let codingKeyDictonary: [String:String] =
    [:]
extension JSONDecoder.KeyDecodingStrategy {
    
    static var convertFromUpperCamelCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in
            
            var key = AnyCodingKey(codingKeys.last!)
            
            // lowercase first letter
            if let firstChar = key.stringValue.first {
                let i = key.stringValue.startIndex
                key.stringValue.replaceSubrange(
                    i ... i, with: String(firstChar).lowercased()
                )
            }
            return key
        }
    }
}

