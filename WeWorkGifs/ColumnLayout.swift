//
//  ColumnsLayout.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/7/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

// inspiration: https://www.raywenderlich.com/107439/uicollectionview-custom-layout-tutorial-pinterest

class ColumnLayout: UICollectionViewLayout {
    weak var delegate: ColumnLayoutDelegate?
    
    fileprivate let columnCount = 2
    fileprivate let spacing: CGFloat = 6.25
    
    private var attributeCache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0.0
    
    private var contentWidth: CGFloat {
        return UIScreen.main.bounds.width - (2.0 * spacing)
    }
    
    private var columnWidth: CGFloat {
        return (contentWidth / CGFloat(columnCount))
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView,
            let delegate = delegate,
            attributeCache.isEmpty else { return }
        
        // keep track of what column a cell is in e.g. [0 | half] cgfloat array
        var xOffset = [CGFloat]()
        
        for column in 0..<columnCount {
            xOffset.append((CGFloat(column) * columnWidth) + spacing)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: spacing, count: columnCount)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let imageHeight = delegate.collectionView(collectionView,
                                                     heightForImageAtIndexPath: indexPath,
                                                     withWidth: columnWidth)
            // height of gif/image plus padding top + bottom
            let height = imageHeight + spacing * 2.0
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: spacing, dy: spacing)
            
            // set the frame as attribute for item at this indexPath + append to cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            attributeCache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY) // shouldn't let content shrink shorter than view
            yOffset[column] = yOffset[column] + height // move down vertically for next cell in that column
            
            // go to the next column for iteration, but if at end cycle back to 0
            column = column >= (columnCount - 1) ? 0 : column + 1
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesCollection = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributeCache {
            if attributes.frame.intersects(rect) {
                attributesCollection.append(attributes)
            }
        }
        
        return attributesCollection
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        attributeCache.removeAll() // need to do this becuase when text is nil there are still attributes for cells
    }
}

protocol ColumnLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}
