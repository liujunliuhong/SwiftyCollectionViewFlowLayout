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
        
        var size = layoutAttributes.size
        
        let widthMode = layoutAttributes.sizeMode.width
        let heightMode = layoutAttributes.sizeMode.height
        
        switch widthMode {
            case .static(let w):
                switch heightMode {
                    case .static:
                        size = layoutAttributes.size
                    case .dynamic:
                        size.width = w
                        size.height = systemLayoutSizeFitting(layoutAttributes.size,
                                                              withHorizontalFittingPriority: .required,
                                                              verticalFittingPriority: .fittingSizeLevel).height
                }
            case .dynamic:
                switch heightMode {
                    case .static(let h):
                        size.width = systemLayoutSizeFitting(layoutAttributes.size,
                                                             withHorizontalFittingPriority: .fittingSizeLevel,
                                                             verticalFittingPriority: .required).width
                        size.height = h
                    case .dynamic:
                        size = systemLayoutSizeFitting(layoutAttributes.size,
                                                       withHorizontalFittingPriority: .fittingSizeLevel,
                                                       verticalFittingPriority: .fittingSizeLevel)
                }
        }
        
        layoutAttributes.size = size
        
        return layoutAttributes
    }
}
