//
//  GifCollectionViewCell.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/3/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit
import SDWebImage

class GifCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var imageView: FLAnimatedImageView!
    static let Identifier = String(describing: GifCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5.0
    }
    
    func configure(with gif: Gif) {
        progressBar.progress = 0.0
        progressBar.isHidden = false
        imageView.sd_setImage(with: URL(string: gif.url),
                              placeholderImage: nil,
                              options: .lowPriority,
                              progress: { [weak self] (receivedSize, expectedSize, _) in
                                let r = Float(receivedSize)
                                let s = Float(expectedSize)
                                
                                DispatchQueue.main.async {
                                    if r == s {
                                        self?.progressBar.isHidden = true
                                    } else {
                                        self?.progressBar.progress = r / s
                                    }
                                }
        })
    }
}
