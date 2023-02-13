//
//  UIView+Size.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by galaxy on 2023/2/11.
//

import Foundation
import UIKit

fileprivate enum LengthMode: Equatable {
    case `static`(length: CGFloat)
    case dynamic(increment: CGFloat = .zero)
}



extension UIView {
    internal func caculate(layout: SwiftyCollectionViewFlowLayout,
                           size: CGSize,
                           sectionModel: SectionModel,
                           sizeMode: SwiftyCollectionViewLayoutSizeMode,
                           supplementaryElementKind: String?) -> CGSize {
        
        var _widthMode: LengthMode!
        var _heightMode: LengthMode!
        
        switch layout.scrollDirection {
            case .vertical:
                var containerWidth = layout.mCollectionView.bounds.width - sectionModel.metrics.sectionInset.left - sectionModel.metrics.sectionInset.right
                
                if let supplementaryElementKind = supplementaryElementKind {
                    if supplementaryElementKind == UICollectionView.elementKindSectionHeader {
                        if !sectionModel.metrics.sectionInsetContainHeader {
                            containerWidth = layout.mCollectionView.bounds.width
                        }
                    }
                    if supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                        if !sectionModel.metrics.sectionInsetContainFooter {
                            containerWidth = layout.mCollectionView.bounds.width
                        }
                    }
                }
                
                switch sizeMode.width {
                    case .static(let w):
                        switch sizeMode.height {
                            case .static(let h):
                                _widthMode = .static(length: w)
                                _heightMode = .static(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .static(length: w)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .static(length: w)
                                _heightMode = .static(length: layout.mCollectionView.frame.height)
                            case .fractionalFull(let divisor):
                                _widthMode = .static(length: w)
                                _heightMode = .static(length: layout.mCollectionView.frame.height / CGFloat(divisor))
                        }
                    case .dynamic(let widthIncrement):
                        switch sizeMode.height {
                            case .static(let h):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .static(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .static(length: layout.mCollectionView.frame.height)
                            case .fractionalFull(let divisor):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .static(length: layout.mCollectionView.frame.height / CGFloat(divisor))
                        }
                    case .full:
                        switch sizeMode.height {
                            case .static(let h):
                                _widthMode = .static(length: containerWidth)
                                _heightMode = .static(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .static(length: containerWidth)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .static(length: containerWidth)
                                _heightMode = .static(length: layout.mCollectionView.frame.height)
                            case .fractionalFull(let divisor):
                                _widthMode = .static(length: containerWidth)
                                _heightMode = .static(length: layout.mCollectionView.frame.height / CGFloat(divisor))
                        }
                    case .fractionalFull(let divisor):
                        var itemWidth = (containerWidth - CGFloat(divisor - UInt(1)) * sectionModel.metrics.interitemSpacing) / CGFloat(divisor)
                        if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                            itemWidth = containerWidth / CGFloat(divisor)
                        }
                        
                        switch sizeMode.height {
                            case .static(let h):
                                _widthMode = .static(length: itemWidth)
                                _heightMode = .static(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .static(length: itemWidth)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .static(length: itemWidth)
                                _heightMode = .static(length: layout.mCollectionView.frame.height)
                            case .fractionalFull(let divisor):
                                _widthMode = .static(length: itemWidth)
                                _heightMode = .static(length: layout.mCollectionView.frame.height / CGFloat(divisor))
                        }
                }
                return caculate(layout: layout,
                                size: size,
                                sectionModel: sectionModel,
                                widthMode: _widthMode,
                                heightMode: _heightMode,
                                containerLength: containerWidth)
            case .horizontal:
                var containerHeight = layout.mCollectionView.bounds.height - sectionModel.metrics.sectionInset.top - sectionModel.metrics.sectionInset.bottom
                
                if let supplementaryElementKind = supplementaryElementKind {
                    if supplementaryElementKind == UICollectionView.elementKindSectionHeader {
                        if !sectionModel.metrics.sectionInsetContainHeader {
                            containerHeight = layout.mCollectionView.bounds.height
                        }
                    }
                    if supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                        if !sectionModel.metrics.sectionInsetContainFooter {
                            containerHeight = layout.mCollectionView.bounds.height
                        }
                    }
                }
                
                switch sizeMode.width {
                    case .static(let w):
                        switch sizeMode.height {
                            case .static(let h):
                                _widthMode = .static(length: w)
                                _heightMode = .static(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .static(length: w)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .static(length: w)
                                _heightMode = .static(length: containerHeight)
                            case .fractionalFull(let divisor):
                                _widthMode = .static(length: w)
                                
                                var itemHeight = (containerHeight - CGFloat(divisor - UInt(1)) * sectionModel.metrics.interitemSpacing) / CGFloat(divisor)
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                _heightMode = .static(length: itemHeight)
                        }
                    case .dynamic(let widthIncrement):
                        switch sizeMode.height {
                            case .static(let h):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .static(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .static(length: containerHeight)
                            case .fractionalFull(let divisor):
                                _widthMode = .dynamic(increment: widthIncrement)
                                
                                var itemHeight = (containerHeight - CGFloat(divisor - UInt(1)) * sectionModel.metrics.interitemSpacing) / CGFloat(divisor)
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                _heightMode = .static(length: itemHeight)
                        }
                    case .full:
                        switch sizeMode.height {
                            case .static(let h):
                                _widthMode = .static(length: layout.mCollectionView.frame.width)
                                _heightMode = .static(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .static(length: layout.mCollectionView.frame.width)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .static(length: layout.mCollectionView.frame.width)
                                _heightMode = .static(length: containerHeight)
                            case .fractionalFull(let divisor):
                                _widthMode = .static(length: layout.mCollectionView.frame.width)
                                
                                var itemHeight = (containerHeight - CGFloat(divisor - UInt(1)) * sectionModel.metrics.interitemSpacing) / CGFloat(divisor)
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                _heightMode = .static(length: itemHeight)
                        }
                    case .fractionalFull(let divisor):
                        let itemWidth = layout.mCollectionView.frame.width / CGFloat(divisor)
                        switch sizeMode.height {
                            case .static(let h):
                                _widthMode = .static(length: itemWidth)
                                _heightMode = .static(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .static(length: itemWidth)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .static(length: itemWidth)
                                _heightMode = .static(length: containerHeight)
                            case .fractionalFull(let divisor):
                                _widthMode = .static(length: itemWidth)
                                
                                var itemHeight = (containerHeight - CGFloat(divisor - UInt(1)) * sectionModel.metrics.interitemSpacing) / CGFloat(divisor)
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                _heightMode = .static(length: itemHeight)
                        }
                }
                return caculate(layout: layout,
                                size: size,
                                sectionModel: sectionModel,
                                widthMode: _widthMode,
                                heightMode: _heightMode,
                                containerLength: containerHeight)
            default:
                break
        }
        return size
    }
}

extension UIView {
    private func caculate(layout: SwiftyCollectionViewFlowLayout,
                          size: CGSize,
                          sectionModel: SectionModel,
                          widthMode: LengthMode,
                          heightMode: LengthMode,
                          containerLength: CGFloat) -> CGSize {
        var size: CGSize = size
        
        switch layout.scrollDirection {
            case .vertical:
                var containerWidth = containerLength
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
                                let newSize = CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)
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
                                let newSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: h)
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
                                let newSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                
                                var w = caculateSize.width
                                var h = caculateSize.height
                                
                                if !w.isLessThanOrEqualTo(containerWidth) {
                                    let newSize = CGSize(width: containerWidth, height: CGFloat.greatestFiniteMagnitude)
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
                var containerHeight = containerLength
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
                                let newSize = CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)
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
                                let newSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: h)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .required)
                                size.width = caculateSize.width + widthIncrement
                                size.height = h
                            case .dynamic(let heightIncrement):
                                // dynamic width and dynamic height
                                let newSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                var w = caculateSize.width
                                var h = caculateSize.height
                                
                                if !h.isLessThanOrEqualTo(containerHeight) {
                                    let newSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: containerHeight)
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
