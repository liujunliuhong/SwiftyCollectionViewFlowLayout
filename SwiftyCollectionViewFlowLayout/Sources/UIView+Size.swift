//
//  UIView+Size.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by galaxy on 2023/2/11.
//

import Foundation
import UIKit


extension UIView {
    internal func caculate(size: CGSize,
                           sizeMode: InternalSizeMode,
                           maxSize: CGSize,
                           scrollDirection: UICollectionView.ScrollDirection) -> CGSize {
        switch scrollDirection {
            case .vertical:
                let containerWidth = maxSize.width
                return caculate(size: size, sizeMode: sizeMode, containerLength: containerWidth, scrollDirection: scrollDirection)
            case .horizontal:
                let containerHeight = maxSize.height
                return caculate(size: size, sizeMode: sizeMode, containerLength: containerHeight, scrollDirection: scrollDirection)
            default:
                break
        }
        return size
    }
}

extension UIView {
    private func caculate(size: CGSize,
                          sizeMode: InternalSizeMode,
                          containerLength: CGFloat,
                          scrollDirection: UICollectionView.ScrollDirection) -> CGSize {
        let widthMode = sizeMode.width
        let heightMode = sizeMode.height
        
        var size: CGSize = size
        
        switch scrollDirection {
            case .vertical:
                var containerWidth = containerLength
                containerWidth -= 0.5
                
                switch widthMode {
                    case .absolute(let w):
                        var w = w
                        switch heightMode {
                            case .absolute(let h):
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
                            case .ratio(let ratio):
                                // static width and height ratio
                                size.width = min(w, containerWidth)
                                size.height = size.width * ratio
                        }
                    case .dynamic(let widthIncrement):
                        switch heightMode {
                            case .absolute(let h):
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
                                h = h + heightIncrement
                                w = w + widthIncrement
                                w = min(w, containerWidth)
                                size.width = w
                                size.height = h
                            case .ratio(let ratio):
                                // dynamic width and height ratio
                                let newSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                                let caculateSize = systemLayoutSizeFitting(newSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .fittingSizeLevel)
                                
                                var w = caculateSize.width
                                
                                if !w.isLessThanOrEqualTo(containerWidth) {
                                    w = containerWidth
                                }
                                w = w + widthIncrement
                                w = min(w, containerWidth)
                                size.width = w
                                size.height = w * ratio
                        }
                    case .ratio(let ratio):
                        switch heightMode {
                            case .absolute(let h):
                                // width ratio and static height
                                var w = h * ratio
                                size.width = min(w, containerWidth)
                                size.height = h
                            case .dynamic(let heightIncrement):
                                // width ratio and dynamic height
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
                                h = h + heightIncrement
                                w = h * ratio
                                w = min(w, containerWidth)
                                size.width = w
                                size.height = h
                            case .ratio:
                                // width ratio and height ratio
                                fatalError("width and height cannot be ratio at the same time")
                        }
                }
            case .horizontal:
                var containerHeight = containerLength
                containerHeight -= 0.5
                
                switch widthMode {
                    case .absolute(let w):
                        switch heightMode {
                            case .absolute(let h):
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
                            case .ratio(let ratio):
                                // static width and height ratio
                                var h = w * ratio
                                h = min(h, containerHeight)
                                size.width = w
                                size.height = h
                        }
                    case .dynamic(let widthIncrement):
                        switch heightMode {
                            case .absolute(let h):
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
                                h = min(h, containerHeight)
                                w = w + widthIncrement
                                
                                size.width = w
                                size.height = h
                            case .ratio(let ratio):
                                // dynamic width and height ratio
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
                                
                                w = w + widthIncrement
                                h = w * ratio
                                h = min(h, containerHeight)
                                
                                size.width = w
                                size.height = h
                        }
                    case .ratio(let ratio):
                        switch heightMode {
                            case .absolute(let h):
                                // width ratio and static height
                                let h = min(h, containerHeight)
                                let w = h * ratio
                                size.width = w
                                size.height = h
                            case .dynamic(let heightIncrement):
                                // width ratio and dynamic height
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
                                h = min(h, containerHeight)
                                w = h * ratio
                                
                                size.width = w
                                size.height = h
                            case .ratio:
                                // width ratio and height ratio
                                fatalError("width and height cannot be ratio at the same time")
                        }
                }
            default:
                break
        }
        
        return size
    }
}
