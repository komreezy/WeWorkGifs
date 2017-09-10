//
//  MockAPI.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/7/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class MockAPI: API {
    var resultType: SearchResult<[JSON]>
    
    init(resultType: SearchResult<[JSON]>) {
        self.resultType = resultType
    }
    
    override func request(for type: GiphyRequest, completion: @escaping SearchCompletionHandler) {
        return completion(self.resultType)
    }
}
