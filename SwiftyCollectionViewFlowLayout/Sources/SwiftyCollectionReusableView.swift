//
//  SwiftyCollectionReusableView.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/9.
//

import UIKit


/// A collection reusable view that coordinates with `SwiftyCollectionViewLayoutAttributes`
/// to determine how to size itself: with self-sizing, or without self-sizing. Use this class
/// (or subclasses) for displaying header and footer supplementary views with `SwiftyCollectionViewFlowLayout`.
open class SwiftyCollectionReusableView: UICollectionReusableView {
    
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let layoutAttributes = layoutAttributes as? SwiftyCollectionViewLayoutAttributes else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        let size = caculate(size: layoutAttributes.size,
                            sizeMode: layoutAttributes.sizeMode,
                            maxSize: layoutAttributes.maxSize,
                            scrollDirection: layoutAttributes.scrollDirection)
        
        layoutAttributes.size = size
        
        return layoutAttributes
    }
}
