//
//  PresentAlert.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/7/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

func alert(with title: String? = nil, message: String, style: UIAlertControllerStyle, and actions: UIAlertAction..., target: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    for action in actions {
        alert.addAction(action)
    }
    
    target.present(alert, animated: true, completion: nil)
}
