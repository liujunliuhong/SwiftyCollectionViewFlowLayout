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
        guard let headerModel = headerModel(at: section) else { return }
        guard let headerFrame = frameForHeader(at: section) else { return }
        headerModel.frame = headerFrame
    }
    
    private func frameForHeader(at section: Int) -> CGRect? {
        guard let sectionModel = sectionModel(at: section) else { return nil }
        guard let headerModel = headerModel(at: section) else { return nil }
        
        let scrollDirection = layout().scrollDirection
        
        let previousSectionTotalLength = previousSectionTotalLength(currentSection: section)
        
        var frame = headerModel.frame
        
        if scrollDirection == .vertical {
            frame.origin.x = .zero
            frame.origin.y = previousSectionTotalLength
            if sectionModel.sectionInsetContainHeader {
                frame.origin.x = sectionModel.sectionInset.left
                frame.origin.y += sectionModel.sectionInset.top
            }
        } else if scrollDirection == .horizontal {
            frame.origin.x = previousSectionTotalLength
            frame.origin.y = .zero
            if sectionModel.sectionInsetContainHeader {
                frame.origin.x += sectionModel.sectionInset.left
                frame.origin.y = sectionModel.sectionInset.top
            }
        }
        return frame
    }
    
//    internal func headerLayoutAttributes(at section: Int) -> UICollectionViewLayoutAttributes? {
//        guard let sectionModel = sectionModel(at: section) else { return nil }
//        guard let headerModel = headerModel(at: section) else { return nil }
//        
//        let indexPath = IndexPath(item: 0, section: section)
//        
//        let attr = SwiftyCollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
//        
//        let scrollDirection = layout().scrollDirection
//        
//        var frame = headerModel.frame
//        
//        if scrollDirection == .vertical {
//            frame.origin.x = sectionModel.sectionInsetContainHeader ? sectionModel.sectionInset.left : .zero
//            frame.origin.y = .zero
//        } else if scrollDirection == .horizontal {
//            frame.origin.x = .zero
//            frame.origin.y = sectionModel.sectionInsetContainHeader ? sectionModel.sectionInset.top : .zero
//        }
//        
//        headerModel.frame = frame
//        attr.frame = frame
//        return attr
//    }
}
