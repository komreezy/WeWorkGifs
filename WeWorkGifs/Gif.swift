//
//  Gif.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/5/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import Foundation

struct Gif {
    var id: String = ""
    var height: Float = 0.0
    var username: String = ""
    var url: String = ""
    
    init(_ dictionary: JSON) {
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        
        if let images = dictionary["images"] as? [String: Any],
            let original = images["original"] as? [String: Any],
            let stringHeight = original["height"] as? String,
            let height = Float(stringHeight) {
            self.height = Float(height)
        }
        
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        
        if let images = dictionary["images"] as? [String: Any],
            let original = images["original"] as? [String: Any],
            let url = original["url"] as? String {
            self.url = url
        }
    }
}
