//
//  ModeState+SizeMode.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/16.
//

import Foundation
import UIKit

extension ModeState {
    internal func correctSizeMode(_ sizeMode: SwiftyCollectionViewLayoutSizeMode,
                                  supplementaryElementKind: String?,
                                  metrics: SectionMetrics) -> InternalSizeMode {
        
        var _widthMode: InternalLengthMode = .absolute(length: Default.size.width)
        var _heightMode: InternalLengthMode = .absolute(length: Default.size.width)
        
        switch scrollDirection {
            case .vertical:
                var containerWidth = collectionViewSize.width - metrics.sectionInset.left - metrics.sectionInset.right
                
                if let supplementaryElementKind = supplementaryElementKind {
                    if supplementaryElementKind == UICollectionView.elementKindSectionHeader {
                        if !metrics.sectionInsetContainHeader {
                            containerWidth = collectionViewSize.width
                        }
                    }
                    if supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                        if !metrics.sectionInsetContainFooter {
                            containerWidth = collectionViewSize.width
                        }
                    }
                }
                
                switch sizeMode.width {
                    case .absolute(let w):
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .absolute(length: w)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .absolute(length: w)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .absolute(length: w)
                                _heightMode = .absolute(length: collectionViewSize.height)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .absolute(length: w)
                                _heightMode = .absolute(length: collectionViewSize.height / CGFloat(divisor))
                            case .ratio(let ratio):
                                _widthMode = .absolute(length: w)
                                _heightMode = .ratio(ratio)
                        }
                    case .dynamic(let widthIncrement):
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .absolute(length: collectionViewSize.height)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .absolute(length: collectionViewSize.height / CGFloat(divisor))
                            case .ratio(let ratio):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .ratio(ratio)
                        }
                    case .full:
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .absolute(length: containerWidth)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .absolute(length: containerWidth)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .absolute(length: containerWidth)
                                _heightMode = .absolute(length: collectionViewSize.height)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .absolute(length: containerWidth)
                                _heightMode = .absolute(length: collectionViewSize.height / CGFloat(divisor))
                            case .ratio(let ratio):
                                _widthMode = .absolute(length: containerWidth)
                                _heightMode = .ratio(ratio)
                        }
                    case .fractionalFull(let divisor):
                        if divisor <= 0 {
                            fatalError("divisor cannot be less than or equal to 0")
                        }
                        let allInteritemSpacing = CGFloat(divisor - UInt(1)) * metrics.interitemSpacing
                        var itemWidth = (containerWidth - allInteritemSpacing) / CGFloat(divisor)
                        if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                            itemWidth = containerWidth / CGFloat(divisor)
                        }
                        
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .absolute(length: collectionViewSize.height)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .absolute(length: collectionViewSize.height / CGFloat(divisor))
                            case .ratio(let ratio):
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .ratio(ratio)
                        }
                    case .ratio(let ratio):
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .ratio(ratio)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .ratio(ratio)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .ratio(ratio)
                                _heightMode = .absolute(length: collectionViewSize.height)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .ratio(ratio)
                                _heightMode = .absolute(length: collectionViewSize.height / CGFloat(divisor))
                            case .ratio(let ratio):
                                _widthMode = .ratio(ratio)
                                _heightMode = .ratio(ratio)
                                fatalError("width and height cannot be ratio at the same time.")
                        }
                }
            case .horizontal:
                var containerHeight = collectionViewSize.height - metrics.sectionInset.top - metrics.sectionInset.bottom
                
                if let supplementaryElementKind = supplementaryElementKind {
                    if supplementaryElementKind == UICollectionView.elementKindSectionHeader {
                        if !metrics.sectionInsetContainHeader {
                            containerHeight = collectionViewSize.height
                        }
                    }
                    if supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                        if !metrics.sectionInsetContainFooter {
                            containerHeight = collectionViewSize.height
                        }
                    }
                }
                
                switch sizeMode.width {
                    case .absolute(let w):
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .absolute(length: w)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .absolute(length: w)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .absolute(length: w)
                                _heightMode = .absolute(length: containerHeight)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .absolute(length: w)
                                
                                let allInteritemSpacing = CGFloat(divisor - UInt(1)) * metrics.interitemSpacing
                                var itemHeight = (containerHeight - allInteritemSpacing) / CGFloat(divisor)
                                
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                _heightMode = .absolute(length: itemHeight)
                            case .ratio(let ratio):
                                _widthMode = .absolute(length: w)
                                _heightMode = .ratio(ratio)
                        }
                    case .dynamic(let widthIncrement):
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .absolute(length: containerHeight)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .dynamic(increment: widthIncrement)
                                
                                let allInteritemSpacing = CGFloat(divisor - UInt(1)) * metrics.interitemSpacing
                                var itemHeight = (containerHeight - allInteritemSpacing) / CGFloat(divisor)
                                
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                _heightMode = .absolute(length: itemHeight)
                                
                            case .ratio(let ratio):
                                _widthMode = .dynamic(increment: widthIncrement)
                                _heightMode = .ratio(ratio)
                        }
                    case .full:
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .absolute(length: collectionViewSize.width)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .absolute(length: collectionViewSize.width)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .absolute(length: collectionViewSize.width)
                                _heightMode = .absolute(length: containerHeight)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .absolute(length: collectionViewSize.width)
                                
                                let allInteritemSpacing = CGFloat(divisor - UInt(1)) * metrics.interitemSpacing
                                var itemHeight = (containerHeight - allInteritemSpacing) / CGFloat(divisor)
                                
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                
                                _heightMode = .absolute(length: itemHeight)
                                
                            case .ratio(let ratio):
                                _widthMode = .absolute(length: collectionViewSize.width)
                                _heightMode = .ratio(ratio)
                        }
                    case .fractionalFull(let divisor):
                        if divisor <= 0 {
                            fatalError("divisor cannot be less than or equal to 0")
                        }
                        let itemWidth = collectionViewSize.width / CGFloat(divisor)
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .absolute(length: containerHeight)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .absolute(length: itemWidth)
                                
                                let allInteritemSpacing = CGFloat(divisor - UInt(1)) * metrics.interitemSpacing
                                var itemHeight = (containerHeight - allInteritemSpacing) / CGFloat(divisor)
                                
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                
                                _heightMode = .absolute(length: itemHeight)
                                
                            case .ratio(let ratio):
                                _widthMode = .absolute(length: itemWidth)
                                _heightMode = .ratio(ratio)
                        }
                    case .ratio(let ratio):
                        switch sizeMode.height {
                            case .absolute(let h):
                                _widthMode = .ratio(ratio)
                                _heightMode = .absolute(length: h)
                            case .dynamic(let heightIncrement):
                                _widthMode = .ratio(ratio)
                                _heightMode = .dynamic(increment: heightIncrement)
                            case .full:
                                _widthMode = .ratio(ratio)
                                _heightMode = .absolute(length: containerHeight)
                            case .fractionalFull(let divisor):
                                if divisor <= 0 {
                                    fatalError("divisor cannot be less than or equal to 0")
                                }
                                _widthMode = .ratio(ratio)
                                
                                let allInteritemSpacing = CGFloat(divisor - UInt(1)) * metrics.interitemSpacing
                                var itemHeight = (containerHeight - allInteritemSpacing) / CGFloat(divisor)
                                
                                if supplementaryElementKind == UICollectionView.elementKindSectionHeader || supplementaryElementKind == UICollectionView.elementKindSectionFooter {
                                    itemHeight = containerHeight / CGFloat(divisor)
                                }
                                
                                _heightMode = .absolute(length: itemHeight)
                                
                            case .ratio(let ratio):
                                _widthMode = .ratio(ratio)
                                _heightMode = .ratio(ratio)
                                fatalError("width and height cannot be ratio at the same time.")
                        }
                }
                
            default:
                break
        }
        return InternalSizeMode(width: _widthMode, height: _heightMode)
    }
}
