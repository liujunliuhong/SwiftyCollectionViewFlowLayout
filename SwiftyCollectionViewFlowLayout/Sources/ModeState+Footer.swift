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
        guard let footerModel = footerModel(at: section) else { return }
        guard let footerFrame = frameForFooter(at: section) else { return }
        footerModel.frame = footerFrame
    }
    
    private func frameForFooter(at section: Int) -> CGRect? {
        guard let sectionModel = sectionModel(at: section) else { return nil }
        guard let footerModel = footerModel(at: section) else { return nil }
        
        let scrollDirection = layout().scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = footerModel.frame
        
        if scrollDirection == .vertical {
            frame.origin.x = .zero
            frame.origin.y = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
            if sectionModel.sectionInsetContainHeader {
                frame.origin.x = sectionModel.sectionInset.left
                frame.origin.y -= sectionModel.sectionInset.bottom
            }
        } else if scrollDirection == .horizontal {
            frame.origin.x = previousSectionTotalLength + sectionModel.footerBeforeLength(scrollDirection: scrollDirection)
            frame.origin.y = .zero
            if sectionModel.sectionInsetContainHeader {
                frame.origin.x -= sectionModel.sectionInset.right
                frame.origin.y = sectionModel.sectionInset.top
            }
        }
        return frame
    }
    
//    internal func footerLayoutAttributes(at section: Int) -> UICollectionViewLayoutAttributes? {
//        guard let sectionModel = sectionModel(at: section) else { return nil }
//        guard let footerModel = footerModel(at: section) else { return nil }
//        
//        let indexPath = IndexPath(item: 0, section: section)
//        
//        let attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
//        
//        let scrollDirection = layout().scrollDirection
//        
//        var frame = footerModel.frame
//        
//        if scrollDirection == .vertical {
//            frame.origin.x = sectionModel.sectionInsetContainHeader ? sectionModel.sectionInset.left : .zero
//            frame.origin.y = .zero
//        } else if scrollDirection == .horizontal {
//            frame.origin.x = .zero
//            frame.origin.y = sectionModel.sectionInsetContainHeader ? sectionModel.sectionInset.top : .zero
//        }
//        
//        footerModel.frame = frame
//        attr.frame = frame
//        return attr
//    }
}
