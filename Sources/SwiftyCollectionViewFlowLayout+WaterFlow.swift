//
//  SwiftyCollectionViewFlowLayout+WaterFlow.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/1.
//

import Foundation
import UIKit

extension SwiftyCollectionViewFlowLayout {
    internal func _layoutWaterFlowAttributesForItem(at indexPath: IndexPath) {
        guard let collectionView = collectionView else { return }
        guard let sectionModel = sectionModels[indexPath.section] as? WaterFlowSectionModel else { return }
        
        let cellAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let itemSize = mDelegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
        
        let numberOfColumns = sectionModel.bodyColumnLengths.count
        
        if numberOfColumns <= 0 { return }
        
        let sectionInset = sectionModel.sectionInset
        
        // Find min
        var minGoup: (index: Int, length: CGFloat) = (0, sectionModel.bodyColumnLengths[0])
        for (index, length) in sectionModel.bodyColumnLengths.enumerated() {
            if length.isLess(than: minGoup.length) {
                minGoup = (index, length)
            }
        }
        
        //
        var item_x: CGFloat = .zero
        var item_y: CGFloat = .zero
        var item_width: CGFloat = .zero
        var item_height: CGFloat = .zero
        
        if scrollDirection == .vertical {
            if itemSize.height.isLessThanOrEqualTo(.zero) { return }
            
            let columnWidth = (collectionView.frame.width - sectionInset.left - sectionInset.right - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = columnWidth
            item_height = itemSize.height
            
            item_x = sectionInset.left + (sectionModel.interitemSpacing + columnWidth) * CGFloat(minGoup.index)
            
            if !minGoup.length.isLessThanOrEqualTo(.zero) {
                item_y = minGoup.length + sectionModel.lineSpacing
                sectionModel.bodyColumnLengths[minGoup.index] = minGoup.length + sectionModel.lineSpacing + item_height
            } else {
                sectionModel.bodyColumnLengths[minGoup.index] = item_height
            }
        } else if scrollDirection == .horizontal {
            if itemSize.width.isLessThanOrEqualTo(.zero) { return }
            
            let columnHeight = (collectionView.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(numberOfColumns - 1) * sectionModel.interitemSpacing) / CGFloat(numberOfColumns)
            
            item_width = itemSize.width
            item_height = columnHeight
            
            item_y = sectionInset.top + (sectionModel.interitemSpacing + columnHeight) * CGFloat(minGoup.index)
            
            if !minGoup.length.isLessThanOrEqualTo(.zero) {
                item_x = minGoup.length + sectionModel.lineSpacing
                sectionModel.bodyColumnLengths[minGoup.index] = minGoup.length + sectionModel.lineSpacing + item_width
            } else {
                sectionModel.bodyColumnLengths[minGoup.index] = item_width
            }
        }
        // Update Cell Attr
        cellAttr.frame = CGRect(x: item_x, y: item_y, width: item_width, height: item_height)
        // Update Section Model
        sectionModel.itemLayoutAttributes.append(cellAttr)
    }
}
