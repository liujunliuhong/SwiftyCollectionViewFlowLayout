//
//  SwiftyCollectionViewFlowLayout+GroupDecoration.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/6.
//

import Foundation
import UIKit


extension SwiftyCollectionViewFlowLayout {
    internal func _layoutGroupDecorationAttributesForItem(at indexPath: IndexPath) {
        guard let collectionView = collectionView else { return }
        guard let decorationElementKind = decorationElementKind else { return }
        guard let sectionModel = sectionModels[indexPath.section] else { return }
        
        let decorationAttr = SwiftyCollectionViewLayoutDecorationAttributes(forDecorationViewOfKind: decorationElementKind, with: indexPath)
        
        guard let decorationExtraAttributes = mDelegate?.collectionView(collectionView, layout: self, decorationExtraAttributes: indexPath.section) else { return }
        
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        var width: CGFloat = .zero
        var height: CGFloat = .zero
        
        if scrollDirection == .vertical {
            x = sectionModel.sectionInset.left
            y = .zero
            width = collectionView.bounds.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right
            height = sectionModel.allItemsLength(scrollDirection: scrollDirection)
            
            decorationAttr.extraAttributes = decorationExtraAttributes
            
            decorationAttr.frame = CGRect(x: x,
                                          y: y,
                                          width: width,
                                          height: height)
            
            sectionModel.groupDecorationAttributes = decorationAttr
        } else if scrollDirection == .horizontal {
            x = .zero
            y = sectionModel.sectionInset.top
            width = sectionModel.allItemsLength(scrollDirection: scrollDirection)
            height = collectionView.bounds.height - sectionModel.sectionInset.top - sectionModel.sectionInset.bottom
            
            decorationAttr.extraAttributes = decorationExtraAttributes
            
            decorationAttr.frame = CGRect(x: x,
                                          y: y,
                                          width: width,
                                          height: height)
            
            sectionModel.groupDecorationAttributes = decorationAttr
        }
    }
}
