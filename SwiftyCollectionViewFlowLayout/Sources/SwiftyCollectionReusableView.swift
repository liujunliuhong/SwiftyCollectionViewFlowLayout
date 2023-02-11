//
//  SwiftyCollectionReusableView.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/9.
//

import UIKit


open class SwiftyCollectionReusableView: UICollectionReusableView {
    
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let layoutAttributes = layoutAttributes as? SwiftyCollectionViewLayoutAttributes else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        guard let sectionModel = layoutAttributes.sectionModel else {
            return layoutAttributes
        }
        
        guard let layout = layoutAttributes.layout else {
            return layoutAttributes
        }
        
        var supplementaryElementKind: String?
        if layoutAttributes.representedElementKind == UICollectionView.elementKindSectionHeader {
            supplementaryElementKind = UICollectionView.elementKindSectionHeader
        } else if layoutAttributes.representedElementKind == UICollectionView.elementKindSectionFooter {
            supplementaryElementKind = UICollectionView.elementKindSectionFooter
        }
        
        
        let sizeMode = layoutAttributes.sizeMode
        
        let size = caculate(layout: layout,
                            size: layoutAttributes.size,
                            sectionModel: sectionModel,
                            sizeMode: sizeMode,
                            supplementaryElementKind: supplementaryElementKind)
        
        layoutAttributes.size = size
        
        return layoutAttributes
    }
}
