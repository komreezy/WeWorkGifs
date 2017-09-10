//
//  APIRouter.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/5/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import Foundation
import Alamofire

enum GiphyRequest {
    case trending
    case search(_: String)
}

extension GiphyRequest {
    private var apiKey: String { return "c0da16d3b3fd45e8b585b61324a6939b" }
    
    var path: String {
        switch self {
        case .trending:
            return "http://api.giphy.com/v1/gifs/trending?api_key=\(apiKey)"
        case .search(let query):
            let formattedQuery = query.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "+")
            return "http://api.giphy.com/v1/gifs/search?q=\(formattedQuery)&api_key=\(apiKey)"
        }
    }
    
    // httpmethod redundant for now but if project were to expand this would be good to have
    var method: Alamofire.HTTPMethod {
        switch self {
        case .trending:
            return .get
        case .search(_):
            return .get
        }
    }
}
