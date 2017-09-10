//
//  MockGifSearchViewModel.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/7/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class MockGifSearchViewModel: NSObject {
    var api: MockAPI?
    var didFetchSuccess: Bool = false
    var didFetchFail: Bool = false
    
    func searchGifs(for request: GiphyRequest) {
        api?.request(for: request) { result in
            switch result {
            case .success(_):
                self.didFetchSuccess = true
            case .failure:
                self.didFetchFail = true
            }
        }
    }
}
