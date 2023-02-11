//
//  SwiftyCollectionViewCell.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/9.
//

import UIKit

open class SwiftyCollectionViewCell: UICollectionViewCell {
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes) as? SwiftyCollectionViewLayoutAttributes else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        guard let sectionModel = layoutAttributes.sectionModel else {
            return layoutAttributes
        }
        
        guard let layout = layoutAttributes.layout else {
            return layoutAttributes
        }
        
        let sizeMode = layoutAttributes.sizeMode
        
        let size = caculate(layout: layout,
                            size: layoutAttributes.size,
                            sectionModel: sectionModel,
                            sizeMode: sizeMode,
                            supplementaryElementKind: nil)
        
        layoutAttributes.size = size
        
        if !contentView.bounds.size.width.isEqual(to: size.width) {
            contentView.bounds.size.width = size.width
        }
        if !contentView.bounds.size.height.isEqual(to: size.height) {
            contentView.bounds.size.height = size.height
        }
        
        return layoutAttributes
    }
}
