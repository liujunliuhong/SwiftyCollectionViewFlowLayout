//
//  ModeState+Header.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit


extension ModeState {
    internal func layoutHeaderModel(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let headerModel = sectionModel.headerModel else { return }
        
        let metrics = sectionModel.metrics
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = headerModel.frame
        
        switch scrollDirection {
            case .vertical:
                frame.origin.y = previousSectionTotalLength
                if metrics.sectionInsetContainHeader {
                    frame.origin.y += metrics.sectionInset.top
                }
                switch metrics.headerDirection {
                    case .left:
                        frame.origin.x = .zero
                        if metrics.sectionInsetContainHeader {
                            frame.origin.x = metrics.sectionInset.left
                        }
                    case .center:
                        frame.origin.x = (collectionViewSize.width - frame.width) / 2.0
                    case .right:
                        frame.origin.x = collectionViewSize.width - frame.width
                        if metrics.sectionInsetContainHeader {
                            frame.origin.x = collectionViewSize.width - frame.width - metrics.sectionInset.right
                        }
                }
            case .horizontal:
                frame.origin.x = previousSectionTotalLength
                if metrics.sectionInsetContainHeader {
                    frame.origin.x += metrics.sectionInset.left
                }
                switch metrics.headerDirection {
                    case .left:
                        frame.origin.y = .zero
                        if metrics.sectionInsetContainHeader {
                            frame.origin.y = metrics.sectionInset.top
                        }
                    case .center:
                        frame.origin.y = (collectionViewSize.height - frame.height) / 2.0
                    case .right:
                        frame.origin.y = collectionViewSize.height - frame.height
                        if metrics.sectionInsetContainHeader {
                            frame.origin.y = collectionViewSize.height - frame.height - metrics.sectionInset.bottom
                        }
                }
            default:
                break
        }
        
        // Offset
        frame.origin.x += metrics.headerOffset.horizontal
        frame.origin.y += metrics.headerOffset.vertical
        
        headerModel.frame = frame
        headerModel.pinnedFrame = frame
    }
    
    internal func headerLayoutAttributes(at section: Int,
                                         frame: CGRect,
                                         sectionModel: SectionModel,
                                         correctSizeMode: InternalSizeMode) -> SwiftyCollectionViewLayoutAttributes {
        let metrics = sectionModel.metrics
        
        var attr: SwiftyCollectionViewLayoutAttributes
        if let cachedAttr = getCachedHeader(at: section) {
            attr = cachedAttr
        } else {
            let indexPath = IndexPath(item: 0, section: section)
            attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
        }
        
        attr.sizeMode = correctSizeMode
        attr.scrollDirection = scrollDirection
        attr.maxSize = maxContainerSize(supplementaryElementKind: UICollectionView.elementKindSectionHeader, metrics: metrics)
        attr.frame = frame
        attr.zIndex = 9999
        return attr
    }
}
