//
//  ModeState+Item.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit

extension ModeState {
    internal func layoutItemModels(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        
        for (i, itemModel) in sectionModel.itemModels.enumerated() {
            let indexPath = IndexPath(item: i, section: section)
            guard let frame = frameForItem(at: indexPath) else { continue }
            itemModel.frame = frame
        }
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        let scrollDirection = layout().scrollDirection
        
        for itemModel in sectionModel.itemModels {
            var frame = itemModel.frame
            if scrollDirection == .vertical {
                frame.origin.y += (previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
            } else if scrollDirection == .horizontal {
                frame.origin.x += (previousSectionTotalLength + sectionModel.bodyBeforeLength(scrollDirection: scrollDirection))
            }
            itemModel.frame = frame
        }
    }
    
    
    private func frameForItem(at indexPath: IndexPath) -> CGRect? {
        guard let itemModel = itemModel(at: indexPath) else { return nil }
        guard let sectionModel = sectionModel(at: indexPath.section) else { return nil }
        
        let collectionView = layout().mCollectionView
        
        if sectionModel.waterFlowBodyColumnLengths.isEmpty { return nil }
        
        let numberOfColumns = sectionModel.waterFlowBodyColumnLengths.count
        
        let scrollDirection = layout().scrollDirection
        
        let sectionInset = sectionModel.sectionInset
        
        var frame = itemModel.frame
        
        // Find min
        var minGoup: (index: Int, length: CGFloat) = (0, sectionModel.waterFlowBodyColumnLengths[0])
        for (index, length) in sectionModel.waterFlowBodyColumnLengths.enumerated() {
            if length.isLess(than: minGoup.length) {
                minGoup = (index, length)
            }
        }
        
        if scrollDirection == .vertical {
            let columnWidth = (collectionView.frame.width - sectionInset.left - sectionInset.right - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
            
            frame.size.width = columnWidth
            
            frame.origin.x = sectionInset.left + (sectionModel.interitemSpacing + columnWidth) * CGFloat(minGoup.index)
            
            if !minGoup.length.isLessThanOrEqualTo(.zero) {
                frame.origin.y = minGoup.length + sectionModel.lineSpacing
                sectionModel.waterFlowBodyColumnLengths[minGoup.index] = minGoup.length + sectionModel.lineSpacing + frame.size.height
            } else {
                frame.origin.y = .zero
                sectionModel.waterFlowBodyColumnLengths[minGoup.index] = frame.size.height
            }
        } else if scrollDirection == .horizontal {
            let columnHeight = (collectionView.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
            
            frame.size.height = columnHeight
            
            frame.origin.y = sectionInset.top + (sectionModel.interitemSpacing + columnHeight) * CGFloat(minGoup.index)
            
            if !minGoup.length.isLessThanOrEqualTo(.zero) {
                frame.origin.x = minGoup.length + sectionModel.lineSpacing
                sectionModel.waterFlowBodyColumnLengths[minGoup.index] = minGoup.length + sectionModel.lineSpacing + frame.size.width
            } else {
                frame.origin.x = .zero
                sectionModel.waterFlowBodyColumnLengths[minGoup.index] = frame.size.width
            }
        }
        return frame
    }
    
//    internal func itemLayoutAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        
//        guard let itemModel = itemModel(at: indexPath)
//        
//        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        
//        return attr
//    }
}
