//
//  GenericWebService.swift
//  Music Search
//
//  Created by Kunal Gandhi on 27.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import Foundation

enum ApiResponseGeneric <T: Decodable> {
    case sucess(T)
    case failure(Error)
}

class GenericWebService {
    
    var defualtSession: URLSession?
    var downloadSession: URLSession?
    
    static let shared = GenericWebService()
    
    
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
    
    private init() {
        self.defualtSession = URLSession(configuration: URLSessionConfiguration.default)
        //        self.downloadSession = URLSession(configuration: URLSessionConfiguration.background(withIdentifier:
        //            "background"), delegate: SearchViewController.self(), delegateQueue: nil)
    }
}
