//
//  API.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/5/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum SearchResult<T> {
    case success(T)
    case failure
}

typealias JSON = [String: Any]

protocol DataFetcher {
    associatedtype K
    typealias SearchCompletionHandler = (SearchResult<K>) -> Void
    func request(for type: GiphyRequest, completion: @escaping SearchCompletionHandler)
}

class API: NSObject, DataFetcher {
    typealias K = [JSON]
    static let shared = API()
    
    func request(for type: GiphyRequest, completion: @escaping SearchCompletionHandler) {
        Alamofire.request(type.path, method: type.method).responseJSON { response in
            if let json = response.result.value as? JSON, response.error == nil {
                if let gifData = json["data"] as? [JSON] {
                    completion(.success(gifData))
                }
            } else {
                completion(.failure)
            }
        }
    }
}

