////
////  QueryService.swift
////  Music Search
////
////  Created by Kunal Gandhi on 12.07.18.
////  Copyright © 2018 Kunal Gandhi. All rights reserved.
////
//
//import Foundation
//
//enum APIResult<T: Decodable> {
//    case success(T)
//    case failure(Error)
//}
//
//class NetworkApiManagerTest {
//
//    var defualtSession: URLSession?
//    var downloadSession: URLSession?
//
////    var downloadTask = URLSessionDownloadTask()
//    typealias resultProccesor = ([Tracks],String?)->()
//
//    static let shared = NetworkApiManager()
//
//    func queryTrack() {
////        uses generic querz and returns üTrack¨
//    }
//
//
//    func query<T: Decodable>(term searchTerm: String, api choosenApi: ApiSelector, completion: @escaping (APIResult<T>) -> ()){
//
//        let baseUrl = generateURLforAPI(api: choosenApi, term: searchTerm)
//        var returnValue: T!
//        let task = defualtSession?.dataTask(with: baseUrl) { data, response, error in
//
//            if let error = error {
//                completion(.failure(error))
//            }
//            let response = response as! HTTPURLResponse
//            if response.statusCode == 200 {
//                print("recieved some data")
//                if let data = data {
//                    let r: T = self.getJsonSerializedData(data: data, apiName: choosenApi.selectedApi.apiName)
//                    returnValue = r
//
//                }
//            }
//            DispatchQueue.main.async {
////                print(items)
//            print(returnValue)
//                completion(.success(returnValue))
//            }
//
//        }
//        task?.resume()
//    }
//
//    private func getJsonSerializedData<U: Decodable>(data: Data, apiName: String) -> U {
//        let decoder = JSONDecoder()
//        return try! decoder.decode(U.self, from: data)
//    }
//
//    private func generateURLforAPI(api choosenApi: ApiSelector, term searchTerm: String) -> URLRequest {
//        var urlComponents = URLComponents(string: choosenApi.selectedApi.baseUrl)
//        var request = URLRequest(url: (urlComponents?.url)!)
//        if choosenApi.selectedApi.apiName == "applemusic" {
//             var tokenString = choosenApi.selectedApi.userToken!
//            urlComponents?.query = "term=\(searchTerm)&include=tracks"
//                request = URLRequest(url: (urlComponents?.url!)!)
//                tokenString = "Bearer " + tokenString
//                request.setValue(tokenString, forHTTPHeaderField: "Authorization")
//        } else if choosenApi.selectedApi.apiName == "itunes" {
//           urlComponents?.query = "media=music&entity=song&term=\(searchTerm)"
//            request = URLRequest(url: (urlComponents?.url!)!)
//
//        }
//        return request
//    }
//
//    private init() {
//        self.defualtSession = URLSession(configuration: URLSessionConfiguration.default)
////        self.downloadSession = URLSession(configuration: URLSessionConfiguration.background(withIdentifier:
////            "background"), delegate: SearchViewController.self(), delegateQueue: nil)
//    }
//////}
//////
//case .sucess(let wrapper):
//var startCount = 0
//let tracks = wrapper.results
//tracks.forEach { (track) in
//    track.identifier = startCount
//    startCount = startCount+1
//}
//let choosenApiApple = ApiSelector.itunes
//let baseUrl2 = self.generateURLforAPI(api: choosenApiApple, term: searchTerm)
//self.query(baseUrl2) { (resultNew: ApiResponseGeneric<SuperWrapper>) in
//    switch resultNew {
//    case .sucess(let wrapperNew):
//        var startCount = 0
//        let tracksNew = wrapperNew.results
//        tracksNew.forEach { (track) in
//            track.identifier = startCount
//            startCount = startCount+1
//        }
//        print(tracksNew)
//        DispatchQueue.main.async {
//            completion(.sucess(tracks))
//}
