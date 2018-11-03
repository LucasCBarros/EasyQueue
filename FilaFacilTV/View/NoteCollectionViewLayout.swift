//
//  NoteCollectionViewLayout.swift
//  FilaFacilTV
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 22/05/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol NoteCollectionViewLayoutDelegate: NSObjectProtocol {
    
    func getAllTexts() -> [String]
        
}

class NoteCollectionViewLayout: UICollectionViewLayout {
    
    open weak var delegate: NoteCollectionViewLayoutDelegate?
    
    // Configurable properties
    let numberOfColumns = 2
    let sectionInset: CGFloat = 0
    let interitemSpacing: CGFloat = 20
    
    //3. Array to keep a cache of attributes.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    //4. Content height and size
    fileprivate var contentHeight: CGFloat = 0

    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll()
        super.prepare()
        // 1. Only calculate once
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        var texts = [String]()
        var columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        if let delegate = self.delegate {
            texts = delegate.getAllTexts()
        }
        var insect: CGFloat
        var interitemSpacing: CGFloat
        var column: Int = 0
        var expectedHeight: CGFloat
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        // 3. Iterates through the list of items in the first section
        for item in 0 ..< numberOfItems {
            insect = 0
            interitemSpacing = 0
            
            if  column == 0 || column == numberOfColumns - 1 {
                insect = -self.sectionInset
            } else {
                interitemSpacing = -self.interitemSpacing
            }
            
            xOffset.append(columnWidth * CGFloat(item) + insect + interitemSpacing)
            
            if column == 0 && column == numberOfColumns - 1 {
                insect -= self.sectionInset
            } else {
                interitemSpacing -= self.interitemSpacing
            }
            
            interitemSpacing /= 2
            
            let itemWidth = columnWidth + insect + interitemSpacing
            
            let indexPath = IndexPath(item: item, section: 0)
            
            expectedHeight = 180
            
            let textHeight = texts[indexPath.row].height(withConstrainedWidth: itemWidth - 50, font: UIFont(name: "SFProDisplay-Regular", size: 31)!)
            
            expectedHeight += textHeight
            
            // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: itemWidth, height: expectedHeight)
            let insetFrame = frame.insetBy(dx: 0, dy: 10)

            // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            // 6. Updates the collection view content height
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + expectedHeight

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
