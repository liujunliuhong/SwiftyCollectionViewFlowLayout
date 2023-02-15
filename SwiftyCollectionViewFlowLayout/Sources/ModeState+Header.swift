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
        guard let layout = layout else { return }
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let headerModel = sectionModel.headerModel else { return }
        
        let scrollDirection = layout.scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = headerModel.frame
        
        switch scrollDirection {
            case .vertical:
                frame.origin.y = previousSectionTotalLength
                if sectionModel.metrics.sectionInsetContainHeader {
                    frame.origin.y += sectionModel.metrics.sectionInset.top
                }
                switch sectionModel.metrics.headerDirection {
                    case .left:
                        frame.origin.x = .zero
                        if sectionModel.metrics.sectionInsetContainHeader {
                            frame.origin.x = sectionModel.metrics.sectionInset.left
                        }
                    case .center:
                        frame.origin.x = (layout.mCollectionView.bounds.width - frame.width) / 2.0
                    case .right:
                        frame.origin.x = layout.mCollectionView.bounds.width - frame.width
                        if sectionModel.metrics.sectionInsetContainHeader {
                            frame.origin.x = layout.mCollectionView.bounds.width - frame.width - sectionModel.metrics.sectionInset.right
                        }
                }
            case .horizontal:
                frame.origin.x = previousSectionTotalLength
                if sectionModel.metrics.sectionInsetContainHeader {
                    frame.origin.x += sectionModel.metrics.sectionInset.left
                }
                switch sectionModel.metrics.headerDirection {
                    case .left:
                        frame.origin.y = .zero
                        if sectionModel.metrics.sectionInsetContainHeader {
                            frame.origin.y = sectionModel.metrics.sectionInset.top
                        }
                    case .center:
                        frame.origin.y = (layout.mCollectionView.bounds.height - frame.height) / 2.0
                    case .right:
                        frame.origin.y = layout.mCollectionView.bounds.height - frame.height
                        if sectionModel.metrics.sectionInsetContainHeader {
                            frame.origin.y = layout.mCollectionView.bounds.height - frame.height - sectionModel.metrics.sectionInset.bottom
                        }
                }
            default:
                break
        }
        
        // Offset
        frame.origin.x += sectionModel.metrics.headerOffset.horizontal
        frame.origin.y += sectionModel.metrics.headerOffset.vertical
        
        headerModel.frame = frame
        headerModel.pinnedFrame = frame
    }
    
    internal func headerLayoutAttributes(at section: Int, frame: CGRect, sectionModel: SectionModel, sizeMode: SwiftyCollectionViewLayoutSizeMode) -> SwiftyCollectionViewLayoutAttributes {
        var attr: SwiftyCollectionViewLayoutAttributes
        if let _attr = cachedHeaderLayoutAttributes[section] {
            attr = _attr
        } else {
            let indexPath = IndexPath(item: 0, section: section)
            attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
        }
        attr.sizeMode = sizeMode
        attr.sectionModel = sectionModel
        attr.layout = layout
        attr.frame = frame
        attr.zIndex = 9999
        return attr
    }
}
