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
                frame.origin.x = .zero
                frame.origin.y = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                if sectionModel.metrics.sectionInsetContainFooter {
                    frame.origin.x = sectionModel.metrics.sectionInset.left
                    frame.origin.y -= sectionModel.metrics.sectionInset.bottom
                }
            case .horizontal:
                frame.origin.x = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
                frame.origin.y = .zero
                if sectionModel.metrics.sectionInsetContainFooter {
                    frame.origin.x -= sectionModel.metrics.sectionInset.right
                    frame.origin.y = sectionModel.metrics.sectionInset.top
                }
            default:
                break
        }
        footerModel.frame = frame
    }
    
    internal func footerLayoutAttributes(at section: Int, frame: CGRect, sectionModel: SectionModel, sizeMode: SwiftyCollectionViewFlowLayoutSizeMode) -> UICollectionViewLayoutAttributes {
        let indexPath = IndexPath(item: 0, section: section)
        let attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
        attr.sizeMode = sizeMode
        attr.layout = layout
        attr.sectionModel = sectionModel
        attr.frame = frame
        return attr
    }
}
