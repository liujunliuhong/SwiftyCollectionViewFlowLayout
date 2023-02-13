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
        guard let layout = layout else { return }
        guard let sectionModel = sectionModel(at: section) else { return }
        guard let footerModel = footerModel(at: section) else { return }
        
        let scrollDirection = layout.scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = footerModel.frame
        
        switch scrollDirection {
            case .vertical:
                frame.origin.y = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                if sectionModel.metrics.sectionInsetContainFooter {
                    frame.origin.y -= sectionModel.metrics.sectionInset.bottom
                }
                switch sectionModel.metrics.footerDirection {
                    case .left:
                        frame.origin.x = .zero
                        if sectionModel.metrics.sectionInsetContainFooter {
                            frame.origin.x = sectionModel.metrics.sectionInset.left
                        }
                    case .center:
                        frame.origin.x = (layout.mCollectionView.bounds.width - frame.width) / 2.0
                    case .right:
                        frame.origin.x = layout.mCollectionView.bounds.width - frame.width
                        if sectionModel.metrics.sectionInsetContainFooter {
                            frame.origin.x = layout.mCollectionView.bounds.width - frame.width - sectionModel.metrics.sectionInset.right
                        }
                }
            case .horizontal:
                frame.origin.x = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                if sectionModel.metrics.sectionInsetContainFooter {
                    frame.origin.x -= sectionModel.metrics.sectionInset.right
                }
                switch sectionModel.metrics.footerDirection {
                    case .left:
                        frame.origin.y = .zero
                        if sectionModel.metrics.sectionInsetContainFooter {
                            frame.origin.y = sectionModel.metrics.sectionInset.top
                        }
                    case .center:
                        frame.origin.y = (layout.mCollectionView.bounds.height - frame.height) / 2.0
                    case .right:
                        frame.origin.y = layout.mCollectionView.bounds.height - frame.height
                        if sectionModel.metrics.sectionInsetContainFooter {
                            frame.origin.y = layout.mCollectionView.bounds.height - frame.height - sectionModel.metrics.sectionInset.bottom
                        }
                }
            default:
                break
        }
        
        // Offset
        frame.origin.x += sectionModel.metrics.footerOffset.horizontal
        frame.origin.y += sectionModel.metrics.footerOffset.vertical
        
        footerModel.frame = frame
    }
    
    internal func footerLayoutAttributes(at section: Int, frame: CGRect, sectionModel: SectionModel, sizeMode: SwiftyCollectionViewLayoutSizeMode) -> UICollectionViewLayoutAttributes {
        let indexPath = IndexPath(item: 0, section: section)
        let attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
        attr.sizeMode = sizeMode
        attr.layout = layout
        attr.sectionModel = sectionModel
        attr.frame = frame
        return attr
    }
}
