//
//  WeWorkGifsTests.swift
//  WeWorkGifsTests
//
//  Created by Komran Ghahremani on 9/2/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import XCTest
@testable import WeWorkGifs

class WeWorkGifsTests: XCTestCase {
    let failedMockAPIManager = MockAPI(resultType: .failure)
    let successMockAPIManager = MockAPI(resultType: .success([
        [
            "bitly_gif_url": "http://gph.is/298jUU3",
            "bitly_url": "http://gph.is/298jUU3",
            "content_url": "",
            "embed_url": "https://giphy.com/embed/AMGW8QmLMmZ8I",
            "id": "AMGW8QmLMmZ8I",
            "url": "https://giphy.com/gifs/AMGW8QmLMmZ8I",
            "username": "",
            "images": [
                "original": [
                    "frames": "61",
                    "height": "250"
                ]
            ]
        ]
    ]))

    func testAPITrendingSuccess() {
        let viewModel = MockGifSearchViewModel()
        viewModel.api = successMockAPIManager
        viewModel.searchGifs(for: .trending)
        
        XCTAssertTrue(viewModel.didFetchSuccess)
        XCTAssertFalse(viewModel.didFetchFail)
    }
    
    func testAPISearchSuccess() {
        let viewModel = MockGifSearchViewModel()
        viewModel.api = successMockAPIManager
        viewModel.searchGifs(for: .search("test query"))
        
        XCTAssertTrue(viewModel.didFetchSuccess)
        XCTAssertFalse(viewModel.didFetchFail)
    }
    
    func testAPITrendingFail() {
        let viewModel = MockGifSearchViewModel()
        viewModel.api = failedMockAPIManager
        viewModel.searchGifs(for: .trending)
        
        XCTAssertFalse(viewModel.didFetchSuccess)
        XCTAssertTrue(viewModel.didFetchFail)
    }
    
    func testAPISearchingFail() {
        let viewModel = MockGifSearchViewModel()
        viewModel.api = failedMockAPIManager
        viewModel.searchGifs(for: .search("test query"))
        
        XCTAssertFalse(viewModel.didFetchSuccess)
        XCTAssertTrue(viewModel.didFetchFail)
    }
}
