//
//  ModeState+Footer.swift
//  SwiftyCollectionViewFlowLayout
//
//  Created by dfsx6 on 2023/2/8.
//

import Foundation
import UIKit


extension ModeState {
    internal func layoutFooterModel(at section: Int) {
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let footerModel = sectionModel.footerModel else { return }
        
        let metrics = sectionModel.metrics
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = footerModel.frame
        
        switch scrollDirection {
            case .vertical:
                frame.origin.y = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                if metrics.sectionInsetContainFooter {
                    frame.origin.y -= metrics.sectionInset.bottom
                }
                switch metrics.footerDirection {
                    case .left:
                        frame.origin.x = .zero
                        if metrics.sectionInsetContainFooter {
                            frame.origin.x = metrics.sectionInset.left
                        }
                    case .center:
                        frame.origin.x = (collectionViewSize.width - frame.width) / 2.0
                    case .right:
                        frame.origin.x = collectionViewSize.width - frame.width
                        if metrics.sectionInsetContainFooter {
                            frame.origin.x = collectionViewSize.width - frame.width - metrics.sectionInset.right
                        }
                }
            case .horizontal:
                frame.origin.x = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                if metrics.sectionInsetContainFooter {
                    frame.origin.x -= metrics.sectionInset.right
                }
                switch metrics.footerDirection {
                    case .left:
                        frame.origin.y = .zero
                        if metrics.sectionInsetContainFooter {
                            frame.origin.y = metrics.sectionInset.top
                        }
                    case .center:
                        frame.origin.y = (collectionViewSize.height - frame.height) / 2.0
                    case .right:
                        frame.origin.y = collectionViewSize.height - frame.height
                        if metrics.sectionInsetContainFooter {
                            frame.origin.y = collectionViewSize.height - frame.height - metrics.sectionInset.bottom
                        }
                }
            default:
                break
        }
        
        // Offset
        frame.origin.x += metrics.footerOffset.horizontal
        frame.origin.y += metrics.footerOffset.vertical
        
        footerModel.frame = frame
        footerModel.pinnedFrame = frame
    }
    
    internal func footerLayoutAttributes(at section: Int,
                                         frame: CGRect,
                                         sectionModel: SectionModel,
                                         correctSizeMode: InternalSizeMode) -> SwiftyCollectionViewLayoutAttributes {
        let metrics = sectionModel.metrics
        
        var attr: SwiftyCollectionViewLayoutAttributes
        if let cachedAttr = getCachedFooter(at: section) {
            attr = cachedAttr
        } else {
            let indexPath = IndexPath(item: 0, section: section)
            attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
        }
        
        attr.sizeMode = correctSizeMode
        attr.scrollDirection = scrollDirection
        attr.maxSize = maxContainerSize(supplementaryElementKind: UICollectionView.elementKindSectionFooter, metrics: metrics)
        attr.frame = frame
        attr.zIndex = 9999
        return attr
    }
}
