//
//  GifSearchViewModel.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/5/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import RxSwift
import RxCocoa

class GifSearchViewModel: NSObject {
    var text = Variable<String>("")
    var results: Variable<[Gif]> = Variable([])
    var error: Variable<String> = Variable<String>("")
    var tinted = Variable<Bool>(false)
    
    func searchGifs(for request: GiphyRequest) {
        API.shared.request(for: request) { result in
            switch result {
            case .success(let json):
                self.results.value = json.flatMap(Gif.init)
                self.tinted.value = self.results.value.count <= 0
            case .failure:
                self.error.value = "Gifs couldn't be loaded"
                break
            }
        }
    }
}
