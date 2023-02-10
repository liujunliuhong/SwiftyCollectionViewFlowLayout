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
                            sizeMode: sizeMode)
        
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

extension SwiftyCollectionViewCell {
    private func caculate(layout: SwiftyCollectionViewFlowLayout,
                          size: CGSize,
                          sectionModel: SectionModel,
                          sizeMode: SwiftyCollectionViewFlowLayoutSizeMode) -> CGSize {
        var size: CGSize = size
        
        let widthMode = sizeMode.width
        let heightMode = sizeMode.height
        
        switch layout.scrollDirection {
            case .vertical:
                var containerWidth = layout.mCollectionView.bounds.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right
                containerWidth -= 0.5
                
                switch widthMode {
                    case .static(let w):
                        var w = w
                        switch heightMode {
                            case .static(let h):
                                // static width and static height
                                size.width = min(w, containerWidth)
                                size.height = h
                            case .dynamic(let heightIncrement):
                                // static width and dynamic height
                                w = min(w, containerWidth)
                                let newSize = CGSize(width: w, height: size.height)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .required,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                size.width = w
                                size.height = caculateSize.height + heightIncrement
                        }
                    case .dynamic(let widthIncrement):
                        switch heightMode {
                            case .static(let h):
                                // dynamic width and static height
                                let newSize = CGSize(width: size.width, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .required)
                                var w = min(caculateSize.width, containerWidth)
                                w += widthIncrement
                                w = min(w, containerWidth)
                                size.width = w
                                size.height = h
                            case .dynamic(let heightIncrement):
                                // dynamic width and dynamic height
                                let newSize = CGSize(width: size.width, height: size.height)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                
                                var w = caculateSize.width
                                var h = caculateSize.height
                                
                                if !w.isLessThanOrEqualTo(containerWidth) {
                                    let newSize = CGSize(width: containerWidth, height: size.height)
                                    let caculateSize = systemLayoutSizeFitting(newSize,
                                                                               withHorizontalFittingPriority: .required,
                                                                               verticalFittingPriority: .fittingSizeLevel)
                                    w = containerWidth
                                    h = caculateSize.height
                                }
                                w = w + widthIncrement
                                size.width = min(w, containerWidth)
                                size.height = h + heightIncrement
                        }
                }
            case .horizontal:
                var containerHeight = layout.mCollectionView.bounds.height - sectionModel.sectionInset.top - sectionModel.sectionInset.bottom
                containerHeight -= 0.5
                
                switch widthMode {
                    case .static(let w):
                        switch heightMode {
                            case .static(let h):
                                // static width and static height
                                let h = min(h, containerHeight)
                                size.width = w
                                size.height = h
                            case .dynamic(let heightIncrement):
                                // static width and dynamic height
                                let newSize = CGSize(width: w, height: size.height)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .required,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                var h = min(containerHeight, caculateSize.height)
                                h = h + heightIncrement
                                size.width = w
                                size.height = min(h, containerHeight)
                        }
                    case .dynamic(let widthIncrement):
                        switch heightMode {
                            case .static(let h):
                                // dynamic width and static height
                                let h = min(h, containerHeight)
                                let newSize = CGSize(width: size.width, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .required)
                                size.width = caculateSize.width + widthIncrement
                                size.height = h
                            case .dynamic(let heightIncrement):
                                // dynamic width and dynamic height
                                let newSize = CGSize(width: size.width, height: size.height)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                var w = caculateSize.width
                                var h = caculateSize.height
                                
                                if !h.isLessThanOrEqualTo(containerHeight) {
                                    let newSize = CGSize(width: size.width, height: containerHeight)
                                    let caculateSize = systemLayoutSizeFitting(newSize,
                                                                               withHorizontalFittingPriority: .fittingSizeLevel,
                                                                               verticalFittingPriority: .required)
                                    w = caculateSize.width
                                    h = containerHeight
                                }
                                h = h + heightIncrement
                                size.width = w + widthIncrement
                                size.height = min(h, containerHeight)
                        }
                }
            default:
                break
        }
        
        return size
    }
}
