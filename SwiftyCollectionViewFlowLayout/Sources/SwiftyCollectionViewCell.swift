//
//  SwiftyCollectionViewCell.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/9.
//

import UIKit

open class SwiftyCollectionViewCell: UICollectionViewCell {
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let layoutAttributes = layoutAttributes as? SwiftyCollectionViewLayoutAttributes else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        var size = layoutAttributes.size
        
        guard let sectionModel = layoutAttributes.sectionModel else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        switch sectionModel.sectionType {
            case .tagList:
                size = tagListCaculate(layoutAttributes: layoutAttributes)
            case .waterFlow:
                size = waterFlowCaculate(layoutAttributes: layoutAttributes)
        }
        
        layoutAttributes.size = size
        
//        if !contentView.bounds.size.width.isEqual(to: size.width) {
//            contentView.bounds.size.width = size.width
//        }
//        if !contentView.bounds.size.height.isEqual(to: size.height) {
//            contentView.bounds.size.height = size.height
//        }
        
        return layoutAttributes
    }
}

extension SwiftyCollectionViewCell {
    private func waterFlowCaculate(layoutAttributes: SwiftyCollectionViewLayoutAttributes) -> CGSize {
        var size = layoutAttributes.size
        
        let widthMode = layoutAttributes.sizeMode.width
        let heightMode = layoutAttributes.sizeMode.height
        
        guard let layout = layoutAttributes.layout else {
            return size
        }
        
        switch layout.scrollDirection {
            case .vertical:
                let w = layoutAttributes.size.width
                switch heightMode {
                    case .static(let h):
                        size.width = w
                        size.height = h
                    case .dynamic:
                        var h = size.height
                        let newSize = CGSize(width: w, height: h)
                        let caculateSize = systemLayoutSizeFitting(newSize,
                                                                   withHorizontalFittingPriority: .required,
                                                                   verticalFittingPriority: .fittingSizeLevel)
                        h = caculateSize.height
                        size.width = w
                        size.height = h
                }
            case .horizontal:
                let h = layoutAttributes.size.height
                switch widthMode {
                    case .static(let w):
                        size.width = w
                        size.height = h
                    case .dynamic:
                        var w = size.width
                        let newSize = CGSize(width: w, height: h)
                        let caculateSize = systemLayoutSizeFitting(newSize,
                                                                   withHorizontalFittingPriority: .fittingSizeLevel,
                                                                   verticalFittingPriority: .required)
                        w = caculateSize.width
                        size.width = w
                        size.height = h
                }
            default:
                break
        }
        return size
    }
    
    private func tagListCaculate(layoutAttributes: SwiftyCollectionViewLayoutAttributes) -> CGSize {
        var size = layoutAttributes.size
        
        guard let layout = layoutAttributes.layout else {
            return size
        }
        guard let sectionModel = layoutAttributes.sectionModel else {
            return size
        }
        
        let widthMode = layoutAttributes.sizeMode.width
        let heightMode = layoutAttributes.sizeMode.height
        
        switch layout.scrollDirection {
            case .vertical:
                let containerWidth = layout.mCollectionView.bounds.width - sectionModel.sectionInset.left - sectionModel.sectionInset.right
                switch widthMode {
                    case .static(let w):
                        var w = w
                        switch heightMode {
                            case .static(let h):
                                var h = h
                                if !w.isLessThanOrEqualTo(containerWidth) {
                                    w = containerWidth
                                    let newSize = CGSize(width: w, height: h)
                                    let caculateSize = systemLayoutSizeFitting(newSize,
                                                                               withHorizontalFittingPriority: .required,
                                                                               verticalFittingPriority: .fittingSizeLevel)
                                    h = caculateSize.height
                                }
                                size.width = w
                                size.height = h
                            case .dynamic:
                                var h = size.height
                                if !w.isLessThanOrEqualTo(containerWidth) {
                                    w = containerWidth
                                }
                                let newSize = CGSize(width: w, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .required,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                h = caculateSize.height
                                size.width = w
                                size.height = h
                        }
                    case .dynamic:
                        var w = size.width
                        switch heightMode {
                            case .static(let h):
                                var h = h
                                let newSize = CGSize(width: w, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .required)
                                w = caculateSize.width
                                if !w.isLessThanOrEqualTo(containerWidth) {
                                    w = containerWidth
                                    let newSize = CGSize(width: w, height: h)
                                    let caculateSize = systemLayoutSizeFitting(newSize,
                                                                               withHorizontalFittingPriority: .required,
                                                                               verticalFittingPriority: .fittingSizeLevel)
                                    h = caculateSize.height
                                }
                                size.width = w
                                size.height = h
                            case .dynamic:
                                var h = size.height
                                let newSize = CGSize(width: w, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .required)
                                w = caculateSize.width
//                                h = caculateSize.height
                                if !w.isLessThanOrEqualTo(containerWidth) {
                                    w = containerWidth
                                    let newSize = CGSize(width: w, height: h)
                                    let caculateSize = systemLayoutSizeFitting(newSize,
                                                                               withHorizontalFittingPriority: .required,
                                                                               verticalFittingPriority: .fittingSizeLevel)
                                    h = caculateSize.height
                                }
                                size.width = w
                                size.height = h
                        }
                }
            case .horizontal:
                let containerHeight = layout.mCollectionView.bounds.height - sectionModel.sectionInset.top - sectionModel.sectionInset.bottom
                switch widthMode {
                    case .static(let w):
                        var w = w
                        switch heightMode {
                            case .static(let h):
                                var h = h
                                if !h.isLessThanOrEqualTo(containerHeight) {
                                    h = containerHeight
                                    let newSize = CGSize(width: w, height: h)
                                    let caculateSize = systemLayoutSizeFitting(newSize,
                                                                               withHorizontalFittingPriority: .fittingSizeLevel,
                                                                               verticalFittingPriority: .required)
                                    w = caculateSize.width
                                }
                                
                                size.width = w
                                size.height = h
                            case .dynamic:
                                var h = size.height
                                let newSize = CGSize(width: w, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .required,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                
                                h = caculateSize.height
                                if !h.isLessThanOrEqualTo(containerHeight) {
                                    h = containerHeight
                                    let newSize = CGSize(width: w, height: h)
                                    let caculateSize = systemLayoutSizeFitting(newSize,
                                                                               withHorizontalFittingPriority: .fittingSizeLevel,
                                                                               verticalFittingPriority: .required)
                                    w = caculateSize.width
                                }
                                
                                size.width = w
                                size.height = h
                        }
                    case .dynamic:
                        var w = size.width
                        switch heightMode {
                            case .static(let h):
                                var h = h
                                if !h.isLessThanOrEqualTo(containerHeight) {
                                    h = containerHeight
                                }
                                let newSize = CGSize(width: w, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .required)
                                w = caculateSize.width
                                
                                size.width = w
                                size.height = h
                            case .dynamic:
                                var w = size.width
                                var h = size.height
                                
                                let newSize = CGSize(width: w, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                w = caculateSize.width
                                h = caculateSize.height
                                if !h.isLessThanOrEqualTo(containerHeight) {
                                    h = containerHeight
                                    let newSize = CGSize(width: w, height: h)
                                    let caculateSize = systemLayoutSizeFitting(newSize,
                                                                               withHorizontalFittingPriority: .fittingSizeLevel,
                                                                               verticalFittingPriority: .required)
                                    w = caculateSize.width
                                }
                                size.width = w
                                size.height = h
                        }
                }
            default:
                break
        }
        
        return size
    }
}
